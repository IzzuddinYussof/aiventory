import json, pathlib
root=pathlib.Path('C:/Programming/aiventory')
artifact='docs/sim_artifacts/20260312-170001-section-11-upload-carousell-flow.json'
now='2026-03-12T17:00:01+08:00'

sp=root/'docs/SIM_STATE_TRACKER.json'
state=json.loads(sp.read_text(encoding='utf-8'))
state['lastRun']={'timestamp':now,'section':'11) Upload Carousell flow','status':'blocked-no-mutation','artifact':artifact}
state['nextSection']='11) Upload Carousell flow'
state['updatedAt']=now
uc=state.get('uploadCarousell',{})
uc['artifact']=artifact
uc['mutation']={'executed':False,'reason':'Skipped (blocker persists).'}
uc['navigationValidation']={
 'targetRoute':'/uploadCarousell','sourceRoute':'/carousell','paramToApiConsistency':True,
 'directRouteNullSafety':False,
 'result':'BLOCKED (source direct navigation omits required runtime param inventoryId)',
 'sourcePushNamedWithoutParams':True,
 'targetRequiredParams':['inventoryId:int','category:String','search:String','searchCategory:String']}
uc['directVsParam']={'paramEntrySupported':True,'directEntrySupported':False,'note':'Direct from Carousell omits params but UploadCarousell initState force-unwraps inventoryId; param mode aligns with POST /inventory_carousell payload.','mismatch':True}
uc['blocker']='Revert impossible with app-exposed contracts: no delete/update endpoint for inventory_carousell rows; existing SIM11 rows remain unreverted.'
uc['revalidation']={'defaultCount':8,'filteredCount':8,'inventoryProbeCount':8,'categoryFirstAllowedCount':4,'topIds':[18,17,15,14,12,11,9,7]}
state['uploadCarousell']=uc
sp.write_text(json.dumps(state,indent=4),encoding='utf-8')

lp=root/'docs/SIM_REVERT_LEDGER.json'
ledger=json.loads(lp.read_text(encoding='utf-8'))
ledger['updatedAt']=now
ledger['entries'].append({'timestamp':now,'section':'11) Upload Carousell flow','mutation':False,'status':'blocked-no-mutation','notes':'Read-only revalidation; mutation skipped because inventory_carousell has no app-exposed delete/update path for exact revert.'})
lp.write_text(json.dumps(ledger,indent=4),encoding='utf-8')

rp=root/'docs/SIM_RUN_LOG.md'
append='''\n\n## 2026-03-12 17:00 MYT - Section 11) Upload Carousell flow (revalidation #13)\n\n### Preamble (target external delivery)\n- Intended recipient: Telegram `59918803` (Owner: Izz)\n- Current section: `11) Upload Carousell flow`\n- APIs to be called this run: `GET /inventory_carousell` (default, filtered, inventory probe, category probe)\n- Mutation + revert expected: No (blocked safety mode)\n- Navigation contract to validate: `/carousell` -> `/uploadCarousell` params + runtime null-safety consistency\n- Direct-vs-param mode coverage for this run: compare direct route entry (no params) vs paramized entry\n\n### Execution\n- Saved raw artifact: `docs/sim_artifacts/20260312-170001-section-11-upload-carousell-flow.json`.\n- Executed read-only live checks only; no mutation performed to avoid introducing additional non-revertable rows.\n\n### End report (target external delivery)\n- Called APIs + status codes:\n  - `GET /inventory_carousell?inventory_ids=[]&name=&category=`: `200`\n  - `GET /inventory_carousell?inventory_ids=[]&name=DICLO&category=BUR`: `200`\n  - `GET /inventory_carousell?inventory_ids=[1357]&name=&category=`: `200`\n  - `GET /inventory_carousell?inventory_ids=[]&name=&category=BUR`: `200`\n- Key extracted app-state vars:\n  - default count: `8`\n  - filtered (DICLO,BUR) count: `8`\n  - inventory probe count/top ids: `8` / `18,17,15,14,12,11,9,7`\n  - category-only (BUR) count: `4`\n- Navigation validation result (source->target + params):\n  - Source `/carousell` navigation still pushes `/uploadCarousell` without params.\n  - Target route/runtime still expects `inventoryId` and force-unwraps it in init state.\n  - Downstream API consistency in param mode remains valid (`inventoryId` -> upload payload `inventory_id`).\n  - Result: BLOCKED (direct path violates required runtime param contract).\n- Direct-vs-param comparison result:\n  - Direct entry: not runtime-safe.\n  - Paramized entry: payload-consistent with API contract.\n  - Mismatch: persists.\n- Findings/issues:\n  - Blocker unchanged: no app-exposed delete/update endpoint for `inventory_carousell`, so exact pre-state revert cannot be guaranteed for mutation path.\n- Revert proof: no mutation executed in this run (safety hold).\n- Next section: remains `11) Upload Carousell flow`.\n'''
rp.write_text(rp.read_text(encoding='utf-8')+append,encoding='utf-8')

mp=root/'docs/USER_FLOW_TODO_MASTER.md'
text=mp.read_text(encoding='utf-8')
needle='- [ ] BLOCKED (2026-03-12 16:55 MYT): read-only revalidation (docs/sim_artifacts/20260312-165405-section-11-upload-carousell-flow.json) confirms blocker persists; direct /carousell -> /uploadCarousell still omits required params while target force-unwraps inventoryId, and mutation remains unsafe because no delete/update revert path exists for inventory_carousell.'
new_line='- [ ] BLOCKED (2026-03-12 17:00 MYT): read-only revalidation (docs/sim_artifacts/20260312-170001-section-11-upload-carousell-flow.json) confirms blocker persists; direct /carousell -> /uploadCarousell still omits required params while target force-unwraps inventoryId, and mutation remains unsafe because no delete/update revert path exists for inventory_carousell.'
if new_line not in text:
    text=text.replace(needle, needle+'\n'+new_line)
mp.write_text(text,encoding='utf-8')

print('UPDATED')
