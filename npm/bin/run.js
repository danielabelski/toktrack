#!/usr/bin/env node
const { execFileSync } = require('child_process');
const fs = require('fs');
const path = require('path');
const os = require('os');

const platform = os.platform();
const arch = os.arch();

function isMusl() {
  if (platform !== 'linux') return false;
  try {
    // Check for musl dynamic linker
    const files = fs.readdirSync('/lib');
    if (files.some(f => f.startsWith('ld-musl-'))) return true;
  } catch {}
  try {
    const lddOutput = execFileSync('ldd', ['--version'], { encoding: 'utf8', stdio: ['pipe', 'pipe', 'pipe'] });
    if (lddOutput.toLowerCase().includes('musl')) return true;
  } catch (e) {
    // ldd --version writes to stderr on musl systems
    if (e.stderr && e.stderr.toString().toLowerCase().includes('musl')) return true;
  }
  return false;
}

// Platform mapping to binary names
const platformMap = {
  'darwin-arm64': 'toktrack-darwin-arm64',
  'darwin-x64': 'toktrack-darwin-x64',
  'linux-x64': 'toktrack-linux-x64',
  'linux-arm64': 'toktrack-linux-arm64',
  'linux-musl-x64': 'toktrack-linux-musl-x64',
  'linux-musl-arm64': 'toktrack-linux-musl-arm64',
  'win32-x64': 'toktrack-win32-x64.exe',
};

const libc = isMusl() ? 'musl-' : '';
const key = `${platform}-${libc}${arch}`;
const binaryName = platformMap[key];

if (!binaryName) {
  console.error(`Unsupported platform: ${key}`);
  console.error('Supported platforms: darwin-arm64, darwin-x64, linux-x64, linux-arm64, linux-musl-x64, linux-musl-arm64, win32-x64');
  process.exit(1);
}

const binary = path.join(__dirname, binaryName);

try {
  execFileSync(binary, process.argv.slice(2), { stdio: 'inherit' });
} catch (e) {
  if (e.status) process.exit(e.status);
  throw e;
}
