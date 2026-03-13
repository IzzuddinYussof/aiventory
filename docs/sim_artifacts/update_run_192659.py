import json, pathlib

root = pathlib.Path(r'C:/Programming/aiventory')
artifact = 'docs/sim_artifacts/20260312-192659-section-11-upload-carousell-flow.json'
iso = '2026-03-12T19:26:59+08:00'
run_time = '2026-03-12 19:26 MYT'

sp = root/'docs/SIM_STATE_TRACKER.json'
state = json.loads(sp.read_text(encoding='utf-8-sig'))
state['lastRun'] = {
    'timestamp': iso,
    'section': '11) Upload Carousell flow (deferred retry)',
    'status': 'blocked-deferred-retry',
    'artifact': artifact
}
state['nextSection'] = 'Deferred retries queue: 12) Cart flow'
state['updatedAt'] = iso

uc = state.get('uploadCarousell', {})
uc['artifact'] = artifact
uc['mutation'] = {'executed': False, 'reason': 'Skipped (blocker persists, deferred retry).'}
uc['navigationValidation'] = {
    'targetRoute': '/uploadCarousell',
    'sourceRoute': '/carousell',
    'paramToApiConsistency': True,
    'directRouteNullSafety': False,
    'result': 'BLOCKED-DEFERRED-RETRY (direct /carousell path omits inventoryId required at runtime)',
    'sourcePushNamedWithoutParams': True,
    'targetRequiredParams': ['inventoryId:int','category:String','search:String','searchCategory:String']
}
uc['directVsParam'] = {
    'paramEntrySupported': True,
    'directEntrySupported': False,
    'mismatch': True,
    'note': 'Deferred retry confirms direct path still omits params while target force-unwraps inventoryId; param mode remains payload-consistent.'
}
uc['blocker'] = 'Revert impossible with app-exposed contracts: no delete/update endpoint for inventory_carousell rows; exact pre-state restoration not achievable.'
uc['revalidation'] = {
    'defaultCount': 8,
    'filteredCount': 8,
    'inventoryProbeCount': 8,
    'categoryFirstAllowedCount': 4,
    'topIds': [18,17,15,14,12,11,9,7]
}
state['uploadCarousell'] = uc

for item in state.get('deferredQueue', []):
    if item.get('section','').startswith('11)'):
        item['latestArtifact'] = artifact
        item['lastRetriedAt'] = iso
        item['retryCountAfterDeferral'] = int(item.get('retryCountAfterDeferral',0)) + 1

sp.write_text(json.dumps(state, indent=4), encoding='utf-8')

lp = root/'docs/SIM_REVERT_LEDGER.json'
ledger = json.loads(lp.read_text(encoding='utf-8-sig'))
ledger['updatedAt'] = iso
ledger['entries'].append({
    'timestamp': iso,
    'section': '11) Upload Carousell flow',
    'mutation': False,
    'status': 'blocked-deferred-retry-no-mutation',
    'notes': f'Deferred retry revalidation: mutation skipped because inventory_carousell still lacks app-exposed delete/update path for exact revert. Evidence: {artifact}'
})
lp.write_text(json.dumps(ledger, indent=4), encoding='utf-8')

mp = root/'docs/USER_FLOW_TODO_MASTER.md'
text = mp.read_text(encoding='utf-8-sig')
new_line = f"- [ ] BLOCKED-DEFERRED-RETRY ({run_time}): deferred retry confirms blocker persists; direct /carousell -> /uploadCarousell still omits runtime-required inventoryId and mutation remains unrevertable due to missing delete/update endpoint for inventory_carousell. Evidence: `{artifact}`."
if new_line not in text:
    insert_after = '- [ ] BLOCKED-DEFERRED-RETRY (2026-03-12 19:18 MYT): deferred retry confirms blocker persists; direct /carousell -> /uploadCarousell still omits runtime-required inventoryId and mutation remains unrevertable due to missing delete/update endpoint for inventory_carousell. Evidence: `docs/sim_artifacts/20260312-191810-section-11-upload-carousell-flow.json`.'
    if insert_after in text:
        text = text.replace(insert_after, insert_after + '\n\n' + new_line)
    else:
        text += '\n' + new_line + '\n'
mp.write_text(text, encoding='utf-8')

rp = root/'docs/SIM_RUN_LOG.md'
append = f'''\n\n## {run_time} - Section 11) Upload Carousell flow (DEFERRED RETRY #3)\n\n### Preamble (target external delivery)\n- Intended recipient: Telegram `59918803` (Owner: Izz)\n- Current section: `11) Upload Carousell flow` (deferred retry)\n- APIs to be called this run: `GET /inventory_carousell` (default, filtered, inventory probe, category probe)\n- Mutation + revert expected: Mutation required by checklist but skipped (existing blocker under Rule 5 exact-revert)\n- Navigation contract to validate: `/carousell -> /uploadCarousell` route contract + runtime param requirements to downstream payload mapping\n- Direct-vs-param mode coverage for this run: direct route entry vs paramized entry\n\n### Execution\n- Executed deferred retry as read-only revalidation; saved raw artifact: `{artifact}`.\n- Reconfirmed direct source navigation still omits query params while target runtime dereferences `inventoryId!`.\n- Mutation intentionally skipped to prevent unrevertable state writes.\n\n### End report (target external delivery)\n- Called APIs + status codes:\n  - `GET /inventory_carousell?inventory_ids=[]&name=&category=`: `200`\n  - `GET /inventory_carousell?inventory_ids=[]&name=DICLO&category=BUR`: `200`\n  - `GET /inventory_carousell?inventory_ids=[1357]&name=&category=`: `200`\n  - `GET /inventory_carousell?inventory_ids=[]&name=&category=BUR`: `200`\n- Key extracted app-state vars:\n  - default count: `8`\n  - filtered (DICLO,BUR) count: `8`\n  - inventory probe count/top ids: `8` / `18,17,15,14,12,11,9,7`\n  - category-only (BUR) count: `4`\n- Navigation validation result:\n  - Source direct transition `/carousell -> /uploadCarousell` still passes no params.\n  - Target runtime still requires `inventoryId` (force-unwrap), so direct mode remains unsafe.\n  - Param-mode mapping remains consistent to upload payload fields.\n  - Result: `BLOCKED-DEFERRED-RETRY`.\n- Direct-vs-param comparison result:\n  - Direct entry: not runtime-safe.\n  - Paramized entry: payload-consistent.\n  - Mismatch: persists.\n- Findings/issues:\n  - Blocker unchanged: no app-exposed delete/update endpoint for `inventory_carousell`, so exact pre-state revert cannot be guaranteed for mutation path.\n- Revert proof (if mutation): no mutation executed in this run (safety hold under Rule 5).\n- Next section: `12) Cart flow` (deferred retry).\n'''
rp.write_text(rp.read_text(encoding='utf-8-sig') + append, encoding='utf-8')

print('UPDATED_DOCS')
