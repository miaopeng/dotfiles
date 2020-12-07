const http = require('http');
const url = require('url');
const path = require('path');
const fs = require('fs');
const { exec, spawn } = require('child_process');

const port = process.argv[2] || 8888;

http
  .createServer((request, response) => {
    const uri = url.parse(request.url).pathname;
    let filename = path.join(process.cwd(), uri);

    console.log('url: ', request.url);

    fs.exists(filename, (exists) => {
      if (!exists) {
        response.writeHead(404, { 'Content-Type': 'text/plain' });
        response.write('404 Not Found\n');
        response.end();
        return;
      }

      if (fs.statSync(filename).isDirectory()) filename += '/index.html';

      fs.readFile(filename, 'binary', (err, file) => {
        if (err) {
          response.writeHead(500, { 'Content-Type': 'text/plain' });
          response.write(`${err}\n`);
          response.end();
          return;
        }

        switch (getExt(uri)) {
          case 'svg':
            response.setHeader('Content-Type', 'image/svg+xml');
            break;
          case 'png':
            response.setHeader('Content-Type', 'image/png');
            break;
          default:
        }

        response.writeHead(200);
        response.write(file, 'binary');
        response.end();
      });
    });
  })
  .listen(parseInt(port, 10), () => {
    const weburl = `http://localhost:${port}`;
    openURL(weburl);
    console.log(
      `Static file server running at\n  => ${weburl}/\nCTRL + C to shutdown`
    );
  });

/**
 * get file extenstion
 * @param {String} uri
 * @return {String}
 */
function getExt(uri) {
  return uri.replace(/.*[./\\]/, '').toLowerCase();
}

/**
 * open url in browser
 * @param {String} weburl
 */
function openURL(weburl) {
  switch (process.platform) {
    case 'darwin':
      exec(`open ${weburl}`);
      break;
    case 'win32':
      exec(`start ${weburl}`);
      break;
    default:
      spawn('xdg-open', [weburl]);
    // I use `spawn` since `exec` fails on my machine (Linux i386).
    // I heard that `exec` has memory limitation of buffer size of 512k.
    // http://stackoverflow.com/a/16099450/222893
    // But I am not sure if this memory limit causes the failure of `exec`.
    // `xdg-open` is specified in freedesktop standard, so it should work on
    // Linux, *BSD, solaris, etc.
  }
}
