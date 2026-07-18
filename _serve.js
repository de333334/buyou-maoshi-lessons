const http=require('http'),fs=require('fs'),path=require('path');
const root=__dirname;
const mt={'.html':'text/html; charset=utf-8','.mp3':'audio/mpeg','.css':'text/css','.js':'text/javascript'};
http.createServer((req,res)=>{
  let p;
  try{ p=decodeURIComponent(req.url.split('?')[0]); }catch(e){ p=req.url.split('?')[0]; }
  if(p==='/'||p==='') p='/index.html';
  const fp=path.join(root,p);
  if(!fp.startsWith(root)){ res.writeHead(403); res.end('403'); return; }
  fs.readFile(fp,(e,d)=>{
    if(e){ res.writeHead(404); res.end('404'); return; }
    res.writeHead(200,{'Content-Type':mt[path.extname(fp)]||'application/octet-stream'});
    res.end(d);
  });
}).listen(8848,()=>console.log('SERVER_UP http://localhost:8848'));
