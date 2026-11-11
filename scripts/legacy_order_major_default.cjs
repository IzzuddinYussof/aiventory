'use strict';
// Inert, narrowly scoped native-graph adapter. No credentials or network I/O.
const assert = require('node:assert/strict');
const clone = x => JSON.parse(JSON.stringify(x));
const MARKER = 'LEGACY_NEW_ORDER_MAJOR_DEFAULT_V1';
const UNIT_CODE = "const item=$var.legacy_order_item;const unit=item&&typeof item.quantity_major==='string'?item.quantity_major.trim():'';return {ok:!!unit,unit:unit||null};";
function binding(name, tag, value) { return {name,tag,value,ignore:false,expand:false,children:[],filters:[]}; }
function build(original) {
  assert.equal(original.id,678);
  assert.equal(original.name,'order_list_status');
  assert.equal(original.auth,1);
  const d=clone(original), conditional=d.run[2];
  assert.equal(conditional.name,'mvp:conditional');
  const statement=conditional.context.expr.expression[0].statement;
  assert.equal(statement.left.tag,'input'); assert.equal(statement.left.operand,'id');
  assert.deepEqual(statement.left.filters,[{arg:[],name:'empty',disabled:false}]);
  assert.equal(statement.right.tag,'const:bool'); assert.equal(statement.right.operand,'true');
  const branch=conditional.context.if.run;
  assert.equal(branch.length,1);
  const add=branch[0];
  assert.equal(add.name,'mvp:dbo_add'); assert.equal(add.context.dbo.id,98);
  assert.deepEqual(add.input.find(x=>x.name==='inventory_id'),binding('inventory_id','input','inventory_id'));
  assert(!add.input.some(x=>['recording_unit','recording_unit_mode'].includes(x.name)));
  const lookup=clone(d.run[0]);
  assert.equal(lookup.name,'mvp:dbo_getby');
  lookup.as='legacy_order_item'; lookup._xsid='f:963e7531-6ba8-42f4-898a-e030bb202901';
  lookup.context={dbo:{id:87},allow_notfound:true};
  lookup.description=MARKER;
  lookup.input=[binding('field_name','const','id'),binding('field_value','input','inventory_id'),binding('lock','const:bool','false')];
  lookup.output={customize:true,filters:[],items:[{name:'id',children:[]},{name:'quantity_major',children:[]}]};
  const resolve={name:'mvp:lambda',as:'legacy_order_unit',context:{},description:MARKER,disabled:false,mocks:{},_xsid:'f:963e7531-6ba8-42f4-898a-e030bb202902',input:[binding('code','const',UNIT_CODE),binding('timeout','const:int','10')],settings_registry:null,output:{customize:false,filters:[],items:[]},addon:[],runtime:null};
  const guard=clone(d.run[1]);
  assert.equal(guard.name,'mvp:precondition');
  guard._xsid='f:963e7531-6ba8-42f4-898a-e030bb202903'; guard.description=MARKER;
  guard.context.expr.expression[0].statement.left.operand='legacy_order_unit.ok';
  guard.context.error={tag:'const',value:'UNIT_NOT_CONFIGURED: ask HQ to set the selected item major unit label.',filters:[]};
  guard.context.error_type='inputerror';
  add.input.push(binding('recording_unit','var','legacy_order_unit.unit'),binding('recording_unit_mode','const','major'));
  branch.unshift(lookup,resolve,guard);
  return d;
}
function reverse(candidate) {
  const d=clone(candidate),branch=d.run[2].context.if.run;
  assert.equal(branch.length,4);
  assert(branch.slice(0,3).every(x=>x.description===MARKER));
  branch.splice(0,3);
  const add=branch[0];
  assert.deepEqual(add.input.slice(-2),[binding('recording_unit','var','legacy_order_unit.unit'),binding('recording_unit_mode','const','major')]);
  add.input.splice(-2);
  return d;
}
module.exports={build,reverse,MARKER,UNIT_CODE};
