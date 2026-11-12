'use strict';
// Inert native graph adapter. Only linked legacy Stock In; NEXT is untouched.
const assert=require('node:assert/strict');
const clone=x=>JSON.parse(JSON.stringify(x));
const MARKER='LEGACY_LINKED_STOCKIN_RECEIPT_V1';
const binding=(name,tag,value)=>({name,tag,value,ignore:false,expand:false,children:[],filters:[]});
const statement=(tag,operand,rtag,value,op='=')=>({expression:[{or:false,type:'statement',group:{expression:[]},statement:{op,left:{tag,filters:[],operand},right:{tag:rtag,filters:[],operand:value,ignore_empty:false}}}]});
function node(name,as='',context={},input=[]){return {name,as,context,input,description:MARKER,disabled:false,mocks:{},_xsid:'',settings_registry:null,output:{customize:false,filters:[],items:[]},addon:[],runtime:null};}
const lambda=(as,code)=>node('mvp:lambda',as,{},[binding('code','const',code),binding('timeout','const:int','10')]);
const query=(as,code,value)=>node('mvp:dbo_direct_query',as,{arg:[{tag:'const:expr2',value,filters:[]}],code,response_type:'single'});
const guard=(operand,message)=>node('mvp:precondition','',{expr:statement('var',operand,'const:bool','true'),error:{tag:'const',value:message,filters:[]},error_type:'inputerror'});
const conditional=(operand,yes,no)=>node('mvp:conditional','',{if:{run:yes},elif:{run:[]},else:{run:no},expr:statement('var',operand,'const:bool','true')});
const REQUEST_CODE=`const i=$input, u=Array.isArray(i.updates)?i.updates[0]:i.updates;
const actor=Number($auth.id),at=Number(u&&u.timestamp);
const p={order_id:Number(i.order_list_id),item:Number(i.inventory_id),branch:String(i.branch||'').trim(),quantity:Number(i.quantity),unit:String(i.unit||'').trim(),expiry:['','Expiry Date','1970-01-01','0'].includes(String(i.expiry_date??''))?'':String(i.expiry_date),unit_cost:Number(i.unit_cost||0),total_cost:Number(i.total_cost||0),note:String(i.note||''),doc:String(i.doc||''),from:Number(i.branch_id_from||0),to:Number(i.branch_id_to||0),actor,at};
return {ok:actor>0&&Number.isSafeInteger(at)&&at>0&&p.order_id>0&&p.item>0&&Number.isFinite(p.quantity)&&p.quantity>0&&!!p.branch&&!!p.unit&&Number.isFinite(p.unit_cost)&&Number.isFinite(p.total_cost),json:JSON.stringify(p),lock:'aiventory-next:item:'+p.item};`;
const READ_SQL=`WITH p AS (SELECT ?::jsonb j) SELECT to_jsonb(o) AS ord,coalesce((SELECT jsonb_agg(m) FROM mvpw1_157 m WHERE m.order_list_id=o.id),'[]'::jsonb) AS movements FROM mvpw1_98 o,p WHERE o.id=(p.j->>'order_id')::bigint FOR UPDATE OF o`;
const PLAN_CODE=`const p=JSON.parse($var.legacy_request.json),db=$var.legacy_db||{};
const o=typeof db.ord==='string'?JSON.parse(db.ord):db.ord,raw=typeof db.movements==='string'?JSON.parse(db.movements):db.movements,ms=raw||[];
const fail=error=>({ok:false,error,replay:false});
if(!o)return fail('ORDER_NOT_FOUND');
if(Number(o.inventory_id)!==p.item||String(o.branch||'').trim()!==p.branch)return fail('ORDER_IDENTITY_MISMATCH');
const receive=o.receive&&typeof o.receive==='object'?o.receive:{};
const receipts=receive.legacy_stockin&&Array.isArray(receive.legacy_stockin.receipts)?receive.legacy_stockin.receipts:[];
const key=p.actor+':'+p.at,signature=JSON.stringify(p),prior=receipts.find(x=>x.key===key);
if(prior){if(prior.signature!==signature)return fail('RECEIPT_RETRY_CONFLICT');const movement=ms.find(m=>Number(m.id)===Number(prior.movement_id));if(!movement)return fail('RECEIPT_MOVEMENT_MISSING');return {ok:true,replay:true,movement};}
if(!['ordered','received'].includes(String(o.status).toLowerCase()))return fail('ORDER_NOT_RECEIVABLE');
if(o.recording_unit&&String(o.recording_unit).trim()!==p.unit)return fail('ORDER_UNIT_MISMATCH');
const tracked=Number(o.quantity_received||0),ordered=Number(o.quantity_ordered||o.amount||0);
const stockins=ms.filter(m=>String(m.tx_type).toLowerCase()==='stock in'&&Number(m.quantity)>0);
if(stockins.some(m=>Number(m.inventory_id)!==p.item||String(m.branch||'').trim()!==p.branch||String(m.unit||'').trim()!==p.unit))return fail('EXISTING_MOVEMENT_IDENTITY_MISMATCH');
const posted=stockins.reduce((n,m)=>n+Number(m.quantity),0);
if(posted>tracked+1e-9)return fail('UNTRACKED_PRIOR_STOCK_REQUIRES_RECONCILIATION');
if(!Number.isFinite(ordered)||ordered<=0||tracked<0||tracked+p.quantity>ordered+1e-9)return fail('QUANTITY_EXCEEDS_REMAINING');
return {ok:true,replay:false,key,signature,received:tracked+p.quantity,closed:tracked+p.quantity>=ordered-1e-9,actor:p.actor,unit:p.unit,quantity:p.quantity,note:p.note};`;
const UPDATE_SQL=`WITH p AS (SELECT ?::jsonb j) UPDATE mvpw1_98 o SET quantity_received=(p.j->>'received')::numeric,status=CASE WHEN (p.j->>'closed')::boolean THEN 'received' ELSE 'ordered' END,receive=coalesce(o.receive,'{}'::jsonb)||jsonb_build_object('name',p.j->>'actor_name','date',(p.j->>'at')::bigint,'remark',p.j->>'note','legacy_stockin',jsonb_build_object('version',1,'receipts',coalesce(o.receive->'legacy_stockin'->'receipts','[]'::jsonb)||jsonb_build_array(p.j-'received'-'closed'-'order_id'-'actor_name'))) FROM p WHERE o.id=(p.j->>'order_id')::bigint RETURNING o.id,o.quantity_received,o.status`;
function buildMovement(original){
 assert.equal(original.id,1102);assert.equal(original.auth,1);assert.equal(original.name,'inventory_movement');assert.equal(original.verb,'POST');
 assert.equal(original.run.length,4);assert.equal(original.run[2].name,'mvp:conditional');assert.equal(original.run[3].context.function.id,82);
 const d=clone(original),originalRun=clone(d.run.slice(2));
 const add=clone(originalRun[0].context.if.run[0]);assert.equal(add.context.dbo.id,157);
 // The original expiry-present branch loses linkage/type/cost. Use the complete add mapping in both linked paths.
 const expiry=add.input.find(x=>x.name==='expiry_date');expiry.ignore=false;expiry.tag='var';expiry.value='legacy_expiry';
 const replay=lambda('inventory_movement','return $var.legacy_plan.movement;');
 const real=[lambda('legacy_expiry',"return JSON.parse($var.legacy_request.json).expiry||null;"),add,
  lambda('legacy_saved_request',"const p=JSON.parse($var.legacy_request.json),s=$var.legacy_plan,m=$var.inventory_movement;return JSON.stringify({...s,order_id:p.order_id,movement_id:m.id,at:m.created_at,actor_name:$var.legacy_actor.name||String(p.actor)});"),
  query('legacy_saved',UPDATE_SQL,'$legacy_saved_request'),clone(originalRun[1])];
 const tx=node('mvp:db_transaction','',{run:[
  query('legacy_item_lock','SELECT pg_advisory_xact_lock(hashtextextended(?,0)) IS NOT NULL AS locked','$legacy_request.lock'),
  query('legacy_db',READ_SQL,'$legacy_request.json'),lambda('legacy_plan',PLAN_CODE),guard('legacy_plan.ok','Linked Stock In rejected: check remaining quantity, order/unit identity or reconcile existing stock; retry payload must be unchanged.'),
  conditional('legacy_plan.replay',[replay],real)]});
 const actor=clone(d.run[0]);actor.as='legacy_actor';actor.description=MARKER;actor.output={customize:true,filters:[],items:[{name:'id',children:[]},{name:'name',children:[]}]};
 const linked=[actor,lambda('legacy_request',REQUEST_CODE),guard('legacy_request.ok','Linked Stock In requires a positive quantity, explicit unit and stable updates.timestamp.'),tx];
 d.run=[...d.run.slice(0,2),lambda('legacy_linked',"return Number($input.order_list_id)>0 && String($input.tx_type||'').trim().toLowerCase()==='stock in';"),conditional('legacy_linked',linked,originalRun)];
 return d;
}
function buildStatus(original){
 assert.equal(original.id,678);assert.equal(original.auth,1);assert.equal(original.name,'order_list_status');assert.equal(original.verb,'PUT');
 const d=clone(original),dispatch=d.run[2];
 assert.equal(dispatch.name,'mvp:conditional');assert.equal(dispatch.context.expr.expression[0].statement.left.operand,'id');
 const before=clone(dispatch.context.else.run);
 // The generic edit runs BEFORE the nested status branches. Intercept the
 // entire existing-ID received request, not just its later audit write.
 assert.equal(before[0].name,'mvp:dbo_editby');assert.equal(before[0].context.dbo.id,98);
 const get=clone(d.run[0]);get.as='legacy_current_order';get.description=MARKER;get.context={dbo:{id:98},allow_notfound:false};get.input=[binding('field_name','const','id'),binding('field_value','input','id'),binding('lock','const:bool','true')];get.output={customize:false,filters:[],items:[]};get.addon=clone(before[0].addon);
 // Both legacy Stock In and the generic editor send indistinguishable received
 // requests. Legacy Received is direct Stock In: neither status-only consumer
 // may fabricate receipt state. NEXT arrival/confirmation routes are separate.
 const tx=node('mvp:db_transaction','',{run:[get,lambda('order_list',"return {...$var.legacy_current_order,receipt_status_changed:false,receipt_status_reason:'LINKED_STOCK_IN_TRANSACTION_OWNS_RECEIPT'};")]});
 const gate=conditional('legacy_received_status_only',[tx],before);
 dispatch.context.else.run=[lambda('legacy_received_status_only',"return $input.status==='received';"),gate];
 return d;
}
module.exports={MARKER,REQUEST_CODE,PLAN_CODE,READ_SQL,UPDATE_SQL,buildMovement,buildStatus};
