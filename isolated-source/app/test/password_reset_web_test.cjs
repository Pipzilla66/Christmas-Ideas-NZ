const fs=require('fs'),vm=require('vm'),assert=require('assert/strict');
const source=fs.readFileSync('app/web_shell/account-setup.js','utf8');
async function setup(search='',hash='',responses=[]){
 const nodes={},calls=[]; const ids=['status','heading','verify','password-form','reset-form','show','password','confirm','save','email','send'];
 for(const id of ids)nodes[id]={hidden:['verify','password-form','reset-form'].includes(id),value:'',handlers:{},addEventListener(e,fn){this.handlers[e]=fn;}};
 let cleared=false;
 await vm.runInNewContext(source,{document:{getElementById:id=>nodes[id]},location:{search,hash,pathname:'/account-setup.html'},history:{replaceState(){cleared=true;}},URLSearchParams,fetch:async(url,options)=>{calls.push({url,options});const data=responses.shift()||{};return {ok:data.ok!==false,text:async()=>JSON.stringify(data.body||{})};}});
 assert(cleared);
 return {nodes,calls,submit:async id=>nodes[id].handlers.submit({preventDefault(){}})};
}
(async()=>{
 let x=await setup(); assert.equal(x.nodes['reset-form'].hidden,false);
 x.nodes.email.value='member@example.com';await x.submit('reset-form'); assert(x.calls[0].url.includes('/recover?redirect_to='));assert(!('code_challenge' in JSON.parse(x.calls[0].options.body)));
 x=await setup('','#access_token=secret&type=recovery',[{body:{id:'member'}}]);
 assert.equal(x.calls[0].options.headers.Authorization,'Bearer secret');assert.equal(x.nodes['password-form'].hidden,false);
 x.nodes.password.value='longpassword';x.nodes.confirm.value='different';await x.submit('password-form');assert.equal(x.calls.length,1);
 x.nodes.confirm.value='longpassword';await x.submit('password-form');assert.equal(x.calls[1].options.method,'PUT');assert.deepEqual(JSON.parse(x.calls[1].options.body),{password:'longpassword'});assert.equal(x.nodes.password.value,'');assert.match(x.nodes.status.textContent,/Password updated/);
 x=await setup('','#access_token=expired&type=recovery',[{ok:false}]);assert.equal(x.nodes['password-form'].hidden,true);assert.equal(x.nodes['reset-form'].hidden,false);
 x=await setup('?token_hash=hash&type=recovery','',[{body:{access_token:'verified'}},{body:{id:'member'}}]);assert.equal(x.calls.length,0);await x.nodes.verify.handlers.click();assert.equal(x.calls.length,2);assert.equal(x.nodes['password-form'].hidden,false);
 x=await setup('?token_hash=hash&type=signup');await x.nodes.verify.handlers.click();assert.match(x.nodes.status.textContent,/Email verified/);assert.equal(x.nodes['password-form'].hidden,true);
 x=await setup('','#error=access_denied');assert.equal(x.nodes['reset-form'].hidden,false);assert.equal(x.calls.length,0);
 console.log('Password reset web checks passed');
})().catch(e=>{console.error(e);process.exit(1);});
