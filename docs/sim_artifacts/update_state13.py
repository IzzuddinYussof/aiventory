import json
p='docs/SIM_STATE_TRACKER.json'
with open(p,'r',encoding='utf-8-sig') as f:data=json.load(f)
artifact='docs/sim_artifacts/20260312-172533-section-13-carousell-update-flow.json'
data['lastRun']={'timestamp':'2026-03-12T17:25:33+08:00','section':'13) Carousell Update flow','status':'blocked','artifact':artifact}
data['updatedAt']='2026-03-12T17:25:33+08:00'
cu=data.get('carousellUpdate',{})
cu['artifact']=artifact
cu['mutation']={'executed':True,'statusCode':200}
cu['navigationValidation']={
 'sourceRoutes':['/carousell','/cart'],'targetRoute':'/carousellUpdate','requiredParams':[],
 'paramPresenceValidated':True,'downstreamApiConsistency':True,
 'result':'BLOCKED (exact-revert failure due buyer_side metadata persistence)'
}
cu['directVsParam']={'directEntrySupported':True,'paramEntrySupported':False,'mismatch':False,'note':'Route is direct-only by design in nav.dart.'}
cu['selectedMovementId']=9
cu['blocker']='Exact pre-state revert failed: buyer_side metadata remained populated after done_bool toggle and cannot be restored via app-exposed PUT contract.'
cu['blockedRunsConsecutive']=2
data['carousellUpdate']=cu
data['nextSection']='13) Carousell Update flow'
with open(p,'w',encoding='utf-8') as f:json.dump(data,f,ensure_ascii=False,indent=4)
