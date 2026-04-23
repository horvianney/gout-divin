const http = require('http');
const fs = require('fs');
const path = require('path');

const port = 8080;

const mimeTypes = {
  '.html': 'text/html',
  '.js': 'text/javascript',
  '.css': 'text/css',
  '.json': 'application/json',
  '.png': 'image/png',
  '.jpg': 'image/jpg',
  '.gif': 'image/gif',
  '.svg': 'image/svg+xml',
  '.wav': 'audio/wav',
  '.mp4': 'video/mp4',
  '.woff': 'application/font-woff',
  '.ttf': 'application/font-ttf',
  '.eot': 'application/vnd.ms-fontobject',
  '.otf': 'application/font-otf',
  '.wasm': 'application/wasm'
};

const server = http.createServer((req, res) => {
  console.log(`${req.method} ${req.url}`);

  // Handle CORS
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') {
    res.writeHead(200);
    res.end();
    return;
  }

  // Determine file path
  let filePath = '.' + req.url;
  if (filePath === './') {
    filePath = './gout-divin-dashboard.html';
  }

  const extname = String(path.extname(filePath)).toLowerCase();
  const mimeType = mimeTypes[extname] || 'application/octet-stream';

  // Read file
  fs.readFile(filePath, (error, content) => {
    if (error) {
      if (error.code === 'ENOENT') {
        // File not found - try to serve dashboard as default
        if (req.url === '/') {
          fs.readFile('./gout-divin-dashboard.html', (err, dashboardContent) => {
            if (err) {
              res.writeHead(500, { 'Content-Type': 'text/html' });
              res.end('<h1>Server Error</h1><p>Could not load dashboard</p>', 'utf-8');
            } else {
              res.writeHead(200, { 'Content-Type': 'text/html' });
              res.end(dashboardContent, 'utf-8');
            }
          });
        } else {
          res.writeHead(404, { 'Content-Type': 'text/html' });
          res.end('<h1>404 Not Found</h1><p>The requested file was not found.</p>', 'utf-8');
        }
      } else {
        // Server error
        res.writeHead(500, { 'Content-Type': 'text/html' });
        res.end('<h1>Server Error</h1><p>Sorry, there was a problem loading the file.</p>', 'utf-8');
      }
    } else {
      // Success - serve the file
      res.writeHead(200, { 'Content-Type': mimeType });
      res.end(content, 'utf-8');
    }
  });
});

server.listen(port, () => {
  console.log(`\n=== GOUT DIVIN Server ===`);
  console.log(`Server running at http://localhost:${port}`);
  console.log(`\nAvailable pages:`);
  console.log(`- Login: http://localhost:${port}/gout-divin-login.html`);
  console.log(`- Dashboard: http://localhost:${port}/gout-divin-dashboard.html`);
  console.log(`- Menu: http://localhost:${port}/gout-divin-menu.html`);
  console.log(`- POS: http://localhost:${port}/gout-divin-pos.html`);
  console.log(`\nPress Ctrl+C to stop the server\n`);
});
