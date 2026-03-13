import json
p='docs/SIM_REVERT_LEDGER.json'
with open(p,'r',encoding='utf-8-sig') as f:data=json.load(f)
entries=data.setdefault('entries',[])
entries.append({
 'timestamp':'2026-03-12T17:25:33+08:00',
 'section':'13) Carousell Update flow',
 'mutation':True,
 'status':'revert-failed-blocker',
 'movementId':9,
 'before':{'status':'Delivered','buyer':False,'seller':False,'buyer_side':{'name':'','date':None}},
 'mutated':{'status':'Delivered','buyer':True,'seller':False,'buyer_side':{'name':'Izzuddin bin Yussof','date':1773307527622}},
 'after':{'status':'Delivered','buyer':False,'seller':False,'buyer_side':{'name':'Izzuddin bin Yussof','date':1773307530738}},
 'proof':'docs/sim_artifacts/20260312-172533-section-13-carousell-update-flow.json',
 'notes':'Second consecutive Section 13 blocker: PUT multipart revert cannot restore buyer_side metadata to pre-state once buyer done_bool is toggled.'
})
data['updatedAt']='2026-03-12T17:25:33+08:00'
with open(p,'w',encoding='utf-8') as f: json.dump(data,f,ensure_ascii=False,indent=4)
