// One UI scenario; this script only prepares and disposes real infrastructure.
const { spawn, spawnSync, fork } = require('node:child_process')
const fs = require('node:fs')
const path = require('node:path')
const { randomUUID, randomBytes } = require('node:crypto')
const { setTimeout: delay } = require('node:timers/promises')

const backendRevision = 'd77b213bd1df8be9d1a9f26b97cf7060cb35e613'
const root = path.resolve(__dirname, '..')
const windows = process.platform === 'win32'
const device = windows ? 'windows' : 'linux'
const runId = randomUUID()
const runDir = path.join(root, '.system-test', runId)
const backend = path.join(runDir, 'backend')
const logDir = path.join(root, '.system-test', 'logs', runId)
const container = `insulog-front-system-${runId}`
const password = randomBytes(24).toString('hex')
const username = `${runId}@example.invalid`
const definesFile = path.join(runDir, 'defines.json')
const preferences = path.join(runDir, 'preferences')
const children = new Set()
let databaseCreated = false
let pool
let apiOutput = ''
let cleaning = false
fs.mkdirSync(logDir, { recursive: true })
fs.mkdirSync(runDir, { recursive: true })

function sanitize(text) {
  return String(text).split(password).join('[REDACTED]')
    .replace(/postgres(?:ql)?:\/\/[^\s'"\]]+/g, '[TEST_DATABASE_URL]')
    .replace(/scrypt:[a-f0-9]+:[a-f0-9]+/g, '[PASSWORD_HASH]')
}
function log(name, output) {
  fs.writeFileSync(path.join(logDir, `${name}.log`), sanitize(output))
}
function kill(child) {
  if (!child.pid || child.exitCode !== null || child.signalCode !== null) return
  if (windows) {
    spawnSync('taskkill', ['/PID', String(child.pid), '/T', '/F'], { windowsHide: true, timeout: 10000 })
  } else {
    try { process.kill(-child.pid, 'SIGKILL') } catch (error) {
      if (error.code !== 'ESRCH') throw error
    }
  }
}
// .bat/.cmd require cmd.exe. Quote trusted arguments and reject cmd expansion.
function command(executable, args) {
  if (!windows || !['flutter', 'npm'].includes(executable)) return [executable, args]
  const parts = [`${executable}.bat`, ...args]
  if (executable === 'npm') parts[0] = 'npm.cmd'
  const located = spawnSync('where.exe', [parts[0]], { encoding: 'utf8', windowsHide: true })
  if (located.status !== 0) throw new Error(`${executable} não encontrado no PATH`)
  parts[0] = located.stdout.trim().split(/\r?\n/)[0]
  if (parts.some(value => /["%\r\n!&|<>^]/.test(value))) throw new Error('Argumento cmd não suportado')
  return [process.env.ComSpec || 'cmd.exe', ['/d', '/s', '/c', `"${parts.map(value => `"${value}"`).join(' ')}"`]]
}
async function run(name, executable, args, options = {}) {
  console.log(`[${name}]`)
  const [program, parameters] = command(executable, args)
  const child = spawn(program, parameters, {
    cwd: options.cwd || root, env: options.env || process.env,
    windowsHide: true, detached: !windows, stdio: ['ignore', 'pipe', 'pipe'],
    windowsVerbatimArguments: windows && ['flutter', 'npm'].includes(executable),
  })
  children.add(child)
  let output = ''
  child.stdout.on('data', data => { output += data })
  child.stderr.on('data', data => { output += data })
  try {
    await new Promise((resolve, reject) => {
      const timer = setTimeout(() => {
        kill(child)
        reject(new Error(`${name}: timeout`))
      }, options.timeout || 300000)
      child.once('error', error => { clearTimeout(timer); reject(error) })
      child.once('close', code => {
        clearTimeout(timer)
        code === 0 ? resolve() : reject(new Error(`${name}: saída ${code}; consulte ${logDir}`))
      })
    })
    return output.trim()
  } finally {
    log(name, output)
    if (child.exitCode !== null || child.signalCode !== null) children.delete(child)
  }
}
async function cleanup() {
  if (cleaning) return
  cleaning = true
  console.log('[Limpar recursos desta execução]')
  for (const child of children) kill(child)
  log('api', apiOutput)
  try {
    if (pool) await pool.end()
  } finally {
    fs.rmSync(definesFile, { force: true })
    const resolvedPreferences = path.resolve(preferences)
    if (path.dirname(resolvedPreferences) !== path.resolve(runDir) ||
        path.dirname(path.resolve(runDir)) !== path.join(root, '.system-test')) {
      throw new Error('Diretório de preferências fora da execução isolada')
    }
    fs.rmSync(resolvedPreferences, { recursive: true, force: true })
    // Exact container name generated above; no prune, global stop or DB cleanup.
    if (databaseCreated) {
      const removed = spawnSync('docker', ['rm', '-f', '-v', container], {
        windowsHide: true, encoding: 'utf8', timeout: 30000,
      })
      log('cleanup', `${removed.stdout || ''}\n${removed.stderr || ''}`)
      if (removed.status !== 0) throw new Error(`Não foi possível remover ${container}; veja cleanup.log`)
    }
  }
}
for (const signal of ['SIGINT', 'SIGTERM']) {
  process.once(signal, () => {
    cleanup().catch(error => console.error(sanitize(error.message))).finally(() => process.exit(1))
  })
}

async function main() {
  if (!windows && process.platform !== 'linux') throw new Error('Execute em Windows ou Linux desktop')
  if (Number(process.versions.node.split('.')[0]) !== 24) throw new Error('Use Node.js 24')
  await run('docker-preflight', 'docker', ['info'], { timeout: 15000 })
  const versionOutput = await run('flutter-version', 'flutter', ['--version', '--machine'])
  const version = JSON.parse(versionOutput.slice(versionOutput.indexOf('{')))
  if (version.frameworkVersion !== '3.41.6') throw new Error('Use Flutter 3.41.6 (Dart 3.11.4)')
  await run('frontend-dependencies', 'flutter', ['pub', 'get', '--enforce-lockfile'])
  await run('backend-clone', 'git', ['clone', '--no-checkout', 'https://github.com/izraelzz/insulog-back-supa', backend])
  await run('backend-revision', 'git', ['checkout', '--detach', backendRevision], { cwd: backend })
  await run('backend-dependencies', 'npm', ['ci'], { cwd: backend })
  // No bind mount or named volume: all fixture data lives in this container.
  databaseCreated = true
  await run('database-start', 'docker', ['run', '--detach', '--name', container,
    '--label', `insulog.system-run=${runId}`, '--publish', '127.0.0.1::5432',
    '--env', 'POSTGRES_USER=insulog_test', '--env', `POSTGRES_PASSWORD=${password}`,
    '--env', 'POSTGRES_DB=insulog_test', '--env', 'TZ=UTC', 'postgres:16.13'], { timeout: 180000 })
  const mapping = await run('database-port', 'docker', ['port', container, '5432/tcp'])
  const port = /^127\.0\.0\.1:(\d+)$/.exec(mapping)?.[1]
  if (!port) throw new Error('Porta local do banco não identificada')
  const databaseUrl = `postgres://insulog_test:${password}@127.0.0.1:${port}/insulog_test`
  const env = { ...process.env, TEST_DATABASE_URL: databaseUrl,
    DATABASE_URL: databaseUrl, SUPABASE_DB_URL: '', DB_SSL: 'false',
    NODE_ENV: 'test', TZ: 'UTC', PORT: '0' }
  const { Pool } = require(path.join(backend, 'node_modules', 'pg'))
  pool = new Pool({ connectionString: databaseUrl, ssl: false,
    connectionTimeoutMillis: 1000, query_timeout: 3000 })
  console.log('[Aguardar PostgreSQL: limite de 60 segundos]')
  const dbDeadline = Date.now() + 60000
  while (true) {
    try { await pool.query('SELECT 1'); break } catch (error) {
      if (Date.now() >= dbDeadline) throw new Error('PostgreSQL indisponível em 60s', { cause: error })
      await delay(250)
    }
  }
  await run('database-schema', 'node', ['scripts/prepare-test-db.cjs'], { cwd: backend, env })
  console.log('[Preparar usuário exclusivo e período Jejum]')
  const { hashPassword } = require(path.join(backend, 'src/services/passwordService.js'))
  // UI maps Jejum to ID 1. This database is new, with no other users or records.
  await pool.query('INSERT INTO periodo (id_periodo, descricao) VALUES (1, $1)', ['Jejum'])
  const user = await pool.query(
    'INSERT INTO usuario (nome, email, senha, tipo_login, tipo_usuario) VALUES ($1, $2, $3, $4, $5) RETURNING id_usuario',
    ['Fixture frontend', username, hashPassword(password), 'email', 'paciente'])
  console.log('[Iniciar API real: limite de 20 segundos]')
  const api = fork(path.join(backend, 'src/server.js'), [], {
    cwd: backend, env, windowsHide: true, detached: !windows,
    stdio: ['ignore', 'pipe', 'pipe', 'ipc'],
  })
  children.add(api)
  api.stdout.on('data', data => { apiOutput += data })
  api.stderr.on('data', data => { apiOutput += data })
  const base = await new Promise((resolve, reject) => {
    const timer = setTimeout(() => reject(new Error('API não iniciou em 20s')), 20000)
    api.once('error', error => { clearTimeout(timer); reject(error) })
    api.once('exit', code => { clearTimeout(timer); reject(new Error(`API encerrou: ${code}`)) })
    api.on('message', message => {
      if (message.type === 'listening' && Number.isInteger(message.port)) {
        clearTimeout(timer)
        resolve(`http://127.0.0.1:${message.port}`)
      }
    })
  })
  const health = await fetch(base, { signal: AbortSignal.timeout(5000) })
  if (!health.ok || (await health.json()).mensagem !== 'API rodando') throw new Error('API indisponível')
  // Previous UTC month guarantees the selected date is never in the future,
  // including at UTC/local midnight boundaries; chosen once for the entire run.
  const now = new Date()
  const date = new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth() - 1, 1))
  const dateString = date.toISOString().slice(0, 10)
  fs.writeFileSync(definesFile, JSON.stringify({ API_BASE_URL: base,
    SYSTEM_USERNAME: username, SYSTEM_PASSWORD: password,
    SYSTEM_USER_ID: String(user.rows[0].id_usuario), SYSTEM_DATE: dateString }), { mode: 0o600 })
  log('execution', `frontend=${spawnSync('git', ['rev-parse', 'HEAD'], { cwd: root, encoding: 'utf8' }).stdout.trim()}\nbackend=${backendRevision}\ndevice=${device}\ndate=${dateString} 12:00:00\nAPI and PostgreSQL TZ=UTC`)
  fs.mkdirSync(preferences, { recursive: true })
  await run('flutter-system-test', 'flutter', ['test', 'integration_test/glucose_history_test.dart',
    '-d', device, '--no-pub', `--dart-define-from-file=${definesFile}`, '--reporter', 'expanded'], {
    env: { ...process.env, TZ: 'UTC', APPDATA: preferences, XDG_DATA_HOME: preferences,
      XDG_CONFIG_HOME: preferences }, timeout: 600000,
  })
  console.log('Teste de sistema passou pela interface com API e banco reais.')
}

main().catch(error => {
  console.error(sanitize(error.message))
  log('failure', error.stack)
  process.exitCode = 1
}).finally(async () => {
  try { await cleanup() } catch (error) {
    console.error(sanitize(error.message))
    process.exitCode = 1
  }
})
