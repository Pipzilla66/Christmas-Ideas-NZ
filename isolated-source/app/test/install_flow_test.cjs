const vm = require('node:vm');
const fs = require('node:fs');
const assert = require('node:assert/strict');
const code = fs.readFileSync('app/web_shell/install.js', 'utf8');
const seenKey = 'christmas-install-intro-seen';
function setup(ua, {installed=false, values=new Map(), blocked=false, hash='', search='', clipboard=true, platform='', touch=0}={}) {
  const events={}, nodes={}, classes=new Set(), timers=[];
  const setTimeout=(fn,delay=0)=>{timers.push({fn,delay});return timers.length};
  const advance=ms=>{for(const timer of timers.splice(0))if(timer.delay<=ms)timer.fn();};
  function node(){return {textContent:'',hidden:false,open:false,children:[],shows:0,addEventListener(type,fn){if(type==='close')this.closeEvent=fn;else this[type]=fn},showModal(){this.open=true;this.shows++},close(){this.open=false;this.closeEvent?.()},replaceChildren(){this.children=[]},appendChild(item){this.children.push(item)},focus(){this.focused=true},select(){this.selected=true}}}
  for(const id of ['#install-button','#install-help','#install-instructions','#install-steps','#close-install','#install-now','#copy-install-link','#install-link-fallback'])nodes[id]=node();
  const storage={getItem(k){if(blocked)throw Error('blocked');return values.get(k)},setItem(k,v){if(blocked)throw Error('blocked');values.set(k,v)}};
  const media={matches:installed,addEventListener(type,fn){this.change=fn}};
  let copied='';
  const document={querySelector:id=>nodes[id],createElement:()=>node(),body:{classList:{toggle(n,v){v?classes.add(n):classes.delete(n)},add(n){classes.add(n)}}}};
  vm.runInNewContext(code,{window:{matchMedia:()=>media,addEventListener:(type,fn)=>events[type]=fn},navigator:{userAgent:ua,platform,maxTouchPoints:touch,clipboard:clipboard?{async writeText(v){copied=v}}:undefined},localStorage:storage,sessionStorage:storage,document,location:{hash,search},URLSearchParams,setTimeout,clearTimeout:()=>{}});
  return {events,nodes,classes,values,media,advance,steps:()=>nodes['#install-steps'].children.map(n=>n.textContent).join(' '),copied:()=>copied};
}
(async()=>{
  for (const ua of ['iPhone Safari','Android Chrome','Chrome','iPhone FBAV']) {
    const fresh=setup(ua);
    assert.equal(fresh.nodes['#install-help'].shows,0);
    fresh.advance(60000);
    assert.equal(fresh.nodes['#install-help'].shows,0);
  }
  const ios=setup('iPhone Safari');
  assert.equal(ios.nodes['#install-help'].shows,0);
  await ios.nodes['#install-button'].click();
  assert.equal(ios.nodes['#install-help'].shows,1);
  assert.match(ios.steps(),/Share.*Add to Home Screen.*Open as Web App/);
  assert.equal(ios.values.get(seenKey),'yes');
  ios.nodes['#close-install'].click();
  const revisit=setup('iPhone Safari',{values:ios.values});
  assert.equal(revisit.nodes['#install-help'].shows,0);
  await revisit.nodes['#install-button'].click();
  assert.equal(revisit.nodes['#install-help'].shows,1);
  const fb=setup('iPhone FBAV');await fb.nodes['#install-button'].click();
  assert.match(fb.steps(),/Open in Safari/);
  assert.equal(fb.nodes['#copy-install-link'].hidden,false);
  await fb.nodes['#copy-install-link'].click();
  assert.equal(fb.copied(),'https://christmasideasnz.co.nz/');
  const fallback=setup('iPhone Messenger',{clipboard:false});await fallback.nodes['#install-button'].click();
  await fallback.nodes['#copy-install-link'].click();
  assert.equal(fallback.nodes['#install-link-fallback'].hidden,false);
  assert.equal(fallback.nodes['#install-link-fallback'].selected,true);
  const android=setup('Android Chrome');await android.nodes['#install-button'].click();
  assert.match(android.steps(),/Install app or Add to Home screen/);
  let prompted=0,prevented=false;
  android.events.beforeinstallprompt({preventDefault(){prevented=true},async prompt(){prompted++},userChoice:Promise.resolve({outcome:'dismissed'})});
  assert.equal(android.nodes['#install-now'].hidden,false);
  assert.equal(prompted,0); // Native installation needs an explicit user tap.
  await android.nodes['#install-now'].click();
  assert.equal(prevented,true); assert.equal(prompted,1);
  await android.nodes['#install-button'].click(); assert.equal(prompted,1);
  android.events.appinstalled(); assert.equal(android.nodes['#install-help'].open,false);
  assert.equal(android.classes.has('installed'),true);
  const accepted=setup('Chrome');
  accepted.events.beforeinstallprompt({preventDefault(){},async prompt(){},userChoice:Promise.resolve({outcome:'accepted'})});
  await accepted.nodes['#install-now'].click(); assert.equal(accepted.nodes['#install-help'].open,false);
  const standalone=setup('iPhone Safari',{installed:true});assert.equal(standalone.nodes['#install-help'].shows,0);
  assert.equal(standalone.classes.has('installed'),true);
  const ipad=setup('Macintosh Safari',{platform:'MacIntel',touch:5});await ipad.nodes['#install-button'].click();assert.match(ipad.steps(),/Home Screen/);
  const desktop=setup('Chrome');await desktop.nodes['#install-button'].click();assert.match(desktop.steps(),/Chrome or Edge/);
  const blocked=setup('iPhone Safari',{blocked:true});await blocked.nodes['#install-button'].click();assert.equal(blocked.nodes['#install-help'].shows,1);
  for(const options of [{hash:'#access_token=private&type=recovery'},{search:'?token_hash=private'},{search:'?code=private'},{hash:'#error=expired'}])assert.equal(setup('iPhone Safari',options).nodes['#install-help'].shows,0);
  const html=fs.readFileSync('dist/index.html','utf8');
  assert.match(html,/install.js\?v=82/);assert.match(html,/apple-touch-logo-v8.png/);
  assert.equal(fs.readFileSync('dist/install.js','utf8'),code);
  console.log('Install checks passed: no automatic pop-up after 60 seconds, first visit, revisit, manual help, iPhone/iPad, embedded browser, clipboard fallback, Android prompt, installed mode, blocked storage, account callbacks, packaged shell.');
})();
