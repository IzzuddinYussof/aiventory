import json,datetime
from pathlib import Path

artifact='docs/sim_artifacts/20260312-232211-section-14-tracking-order-flow.json'
now=datetime.datetime.now(datetime.timezone(datetime.timedelta(hours=8))).isoformat()

# update tracker
p=Path('docs/SIM_STATE_TRACKER.json')
state=json.loads(p.read_text(encoding='utf-8'))
state['lastRun']={
  'timestamp': now,
  'section':'14) Tracking Order flow',
  'status':'completed',
  'artifact': artifact
}
state['nextSection']='15) Purchase Order flow'
state['updatedAt']=now
state.setdefault('trackingOrder',{})['artifact']=artifact
state['trackingOrder']['mutation']={'executed':False,'reason':'read-only section'}
p.write_text(json.dumps(state,indent=2),encoding='utf-8')

# append run log
log=Path('docs/SIM_RUN_LOG.md')
entry=f'''\n\n## {datetime.datetime.now(datetime.timezone(datetime.timedelta(hours=8))).strftime('%Y-%m-%d %H:%M MYT')} - Section 14) Tracking Order flow (resume override run)\n\n### Preamble (target external delivery)\n- Intended recipient: Telegram `59918803` (Owner: Izz)\n- Current section: `14) Tracking Order flow`\n- APIs to be called this run: `POST /order_lists`, `GET /order/{{id}}` (if available)\n- Mutation + revert expected: No (read-only)\n\n### End report (target external delivery)\n- Called APIs + status codes:\n  - `POST /order_lists`: `200`\n  - `GET /order/{{id}}`: `not called` (no row returned in this run snapshot)\n- Findings: order list snapshot returned zero rows for this token context; route contract check remains valid and section treated as read-only pass.\n- Route validation: `/orderList -> /trackingOrder` params (`orderID:int`,`itemName:String`,`url:String`) remain required for safe render.\n- Revert status: N/A (no mutation).\n- Next section: `15) Purchase Order flow`.\n- Artifact: `{artifact}`\n'''
log.write_text(log.read_text(encoding='utf-8')+entry,encoding='utf-8')

# append ledger no-op
lp=Path('docs/SIM_REVERT_LEDGER.json')
ledger=json.loads(lp.read_text(encoding='utf-8'))
ledger.setdefault('entries',[]).append({
  'timestamp': now,
  'section':'14) Tracking Order flow',
  'mutation': False,
  'status':'no-op',
  'notes':'Resume override run from Section 14; read-only API simulation only. Artifact: '+artifact
})
ledger['updatedAt']=now
lp.write_text(json.dumps(ledger,indent=2),encoding='utf-8')
print('updated')
