'use strict';
const fs=require('node:fs'),assert=require('node:assert/strict'),vm=require('node:vm');
const {build,reverse}=require('./legacy_order_major_default.cjs');
const root=process.env.LEGACY_MAJOR_EVIDENCE;
assert(root,'Set LEGACY_MAJOR_EVIDENCE to private captured definitions');
const before=JSON.parse(fs.readFileSync(root+'/before-678.json'));
const candidate=process.env.LEGACY_MAJOR_GRAPH?JSON.parse(fs.readFileSync(process.env.LEGACY_MAJOR_GRAPH)):build(before);
assert.deepEqual(reverse(candidate).run,before.run);
const restored=reverse(candidate); restored.updated_at=before.updated_at; restored.history=before.history;
assert.deepEqual(restored,before,'No unrelated resource metadata drift');
const initialNext=JSON.parse(fs.readFileSync(root+'/before-4164.json'));
if(fs.existsSync(root+'/after-4164.json'))assert.deepEqual(JSON.parse(fs.readFileSync(root+'/after-4164.json')),initialNext,'NEXT unchanged');
let count=0;
const test=(name,fn)=>{fn();console.log('PASS',++count,name)};
const read=(o,p)=>p.split('.').reduce((v,k)=>v?.[k],o);
function value(v,env){
 let x=v.tag==='input'?read(env.input,v.value??v.operand):v.tag==='var'?read(env.vars,v.value??v.operand):v.tag==='auth'?read(env.auth,v.value??v.operand):v.tag==='const:bool'?(v.value??v.operand)==='true':v.tag==='const:null'?null:v.tag==='const:obj'?JSON.parse(v.value||'{}'):v.tag==='const:epochms'?1000:(v.value??v.operand);
 for(const f of v.filters||[]){if(f.disabled)continue;if(f.name==='empty')x=x==null||x===''||(Array.isArray(x)&&!x.length);else if(f.name==='to_int')x=parseInt(x,10);else if(f.name==='set'){x={...x,[value(f.arg[0],env)]:value(f.arg[1],env)}}else throw Error('Unimplemented filter '+f.name)}return x;
}
function expr(x,env){assert.equal(x.expression.length,1);const s=x.expression[0].statement;assert.equal(s.op,'=');return value(s.left,env)===value(s.right,env)}
// Executes the captured native node graph with isolated DB adapters, never production writes.
function execute(input,item,active=true){const env={input,vars:{},auth:{id:8},writes:[],lookups:[],existingPath:false};
 function run(nodes){for(const n of nodes){if(n.disabled)continue;
  if(n.name==='mvp:dbo_getby'){const fields=Object.fromEntries(n.input.filter(i=>!i.ignore).map(i=>[i.name,value(i,env)]));env.lookups.push({table:n.context.dbo.id,...fields});let row=n.context.dbo.id===1?{id:8,active}:n.context.dbo.id===87?(item&&Number(item.id)===Number(fields.field_value)?item:null):undefined;assert.notEqual(row,undefined,'Unknown lookup adapter');env.vars[n.as]=row;}
  else if(n.name==='mvp:precondition'){if(!expr(n.context.expr,env)){const e=Error(value(n.context.error,env));e.type=n.context.error_type;throw e;}}
  else if(n.name==='mvp:lambda'){const code=n.input.find(i=>i.name==='code').value;env.vars[n.as]=vm.runInNewContext('(function(){'+code+'})()',{ $var:env.vars,$input:input },{timeout:1000});}
  else if(n.name==='mvp:conditional'){if(expr(n.context.expr,env))run(n.context.if.run);else env.existingPath=true;}
  else if(n.name==='mvp:dbo_add'){assert.equal(n.context.dbo.id,98);const row=Object.fromEntries(n.input.filter(i=>!i.ignore).map(i=>[i.name,value(i,env)]));env.writes.push(row);env.vars[n.as]=row;}
  else throw Error('Unimplemented native node '+n.name);
 }}
 run(candidate.run);return env;}
const base={status:'submitted',inventory_id:1662,amount:3,branch:'BRANCH',branch_id:'12',name:'Actor',remark:'Keep',channel:'legacy',image_url:''};
for(const unit of ['PACK','BOX','PIECES','Box'])test('canonical '+unit+' and no conversion',()=>{const e=execute(base,{id:1662,quantity_major:unit,quantity_minor:'PIECES',ratio:10,recording_unit_mode:'minor'});assert.equal(e.writes.length,1);const row=e.writes[0];assert.equal(row.recording_unit,unit);assert.equal(row.recording_unit_mode,'major');assert.equal(row.amount,3);assert.equal(row.quantity_ordered,3);assert.equal(row.inventory_id,1662);assert.equal(row.branch,'BRANCH');assert.equal(row.branch_id,12);assert.equal(row.note,'Keep');assert.equal(row.submit.name,'Actor');assert.equal(row.status,'submitted')});
for(const major of [null,undefined,'','  ','\t\n',42,{},[]])test('missing/invalid major '+JSON.stringify(major),()=>assert.throws(()=>execute(base,{id:1662,quantity_major:major}),e=>e.type==='inputerror'&&e.message.startsWith('UNIT_NOT_CONFIGURED')));
test('canonical item absent, no fallback',()=>assert.throws(()=>execute(base,null),/UNIT_NOT_CONFIGURED/));
test('canonical wrong id rejected',()=>assert.throws(()=>execute(base,{id:999,quantity_major:'BOX'}),/UNIT_NOT_CONFIGURED/));
test('incoming mismatch/malicious unit cannot override canonical',()=>{const e=execute({...base,unit:'PIECES',recording_unit:'<script>',recording_unit_mode:'minor',quantity_major:'BAD',legacy_order_item:{quantity_major:'BAD'}},{id:1662,quantity_major:'PACK'});assert.equal(e.writes[0].recording_unit,'PACK');assert.equal(e.writes[0].recording_unit_mode,'major')});
test('missing legacy optional inputs works',()=>{const e=execute({inventory_id:1662,amount:2},{id:1662,quantity_major:'BOX'});assert.equal(e.writes[0].recording_unit,'BOX')});
test('fractional amount preserved without implicit ratio conversion',()=>{let e=execute({...base,amount:2.5},{id:1662,quantity_major:'PACK',ratio:100});assert.equal(e.writes[0].quantity_ordered,2.5)});
test('major outer whitespace normalized',()=>assert.equal(execute(base,{id:1662,quantity_major:' PACK '}).writes[0].recording_unit,'PACK'));
test('inactive staff denied before item lookup/write',()=>assert.throws(()=>execute(base,{id:1662,quantity_major:'PACK'},false),e=>e.type==='accessdenied'));
for(const status of ['approved','received','ordered','submitted','cancelled'])test('existing '+status+' branch untouched',()=>{let e=execute({...base,id:'123',status},null);assert(e.existingPath);assert.equal(e.writes.length,0);assert.equal(e.lookups.length,1);assert.deepEqual(candidate.run[2].context.else,before.run[2].context.else)});
test('auth inputs results notifications prices and all unrelated logic exactly preserved',()=>assert.deepEqual(restored,before));
console.log(JSON.stringify({ok:true,tests:count,evidence:'captured actual native nodes, isolated adapters; no live order created'}));
