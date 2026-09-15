const {
  default: makeWASocket,
  useMultiFileAuthState,
  DisconnectReason
} = require('@whiskeysockets/baileys')

const pino = require('pino')
const readline = require('readline')

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
})

async function startF4MILLY() {
  const { state, saveCreds } =
    await useMultiFileAuthState('./sessions')

  const sock = makeWASocket({
    auth: state,
    logger: pino({ level: 'silent' })
  })

  sock.ev.on('creds.update', saveCreds)

  if (!sock.authState.creds.registered) {
    const phone = await new Promise(resolve => {
      rl.question('📱 Nomor WhatsApp (+62...): ', resolve)
    })

    const number = phone.replace(/\D/g, '')

    const code = await sock.requestPairingCode(number)

    console.log('\n🔑 PAIRING CODE:', code)
    console.log('📱 WhatsApp → Setelan → Perangkat tertaut')
    console.log('→ Tautkan perangkat → Tautkan dengan nomor telepon\n')
  }

  sock.ev.on('connection.update', ({ connection, lastDisconnect }) => {
    if (connection === 'open') {
      console.log('✅ F4MILLY TERHUBUNG KE WHATSAPP!')
    }

    if (connection === 'close') {
      const statusCode =
        lastDisconnect?.error?.output?.statusCode

      console.log('❌ Koneksi terputus:', statusCode)

      if (statusCode !== DisconnectReason.loggedOut) {
        setTimeout(startF4MILLY, 3000)
      }
    }
  })
}

startF4MILLY()
