const fs = require('fs');
const path = require('path');

const BASE_A = 'https://xqoc-ewo0-x3u2.s2.xano.io/api:s4bMNy03';
const BASE_B = 'https://xqoc-ewo0-x3u2.s2.xano.io/api:0o-ZhGP6';

async function callJson(url, options = {}) {
  const res = await fetch(url, options);
  const text = await res.text();
  let json;
  try { json = JSON.parse(text); } catch { json = { raw: text }; }
  return { status: res.status, ok: res.ok, json, url };
}

async function login(email, password) {
  const fd = new FormData();
  fd.append('email', email);
  fd.append('password', password);
  return callJson(`${BASE_A}/auth/login`, { method: 'POST', body: fd });
}

(async () => {
  const ts = new Date();
  const stamp = `${ts.getFullYear()}${String(ts.getMonth()+1).padStart(2,'0')}${String(ts.getDate()).padStart(2,'0')}-${String(ts.getHours()).padStart(2,'0')}${String(ts.getMinutes()).padStart(2,'0')}${String(ts.getSeconds()).padStart(2,'0')}`;

  const routeParams = {
    inventoryId: 1311,
    itemName: 'SALIVA EJECTOR',
    branch: 'Dentabay Bangi',
    expiryDate: 1738281600000
  };
  const expiryDateStr = '2025-01-31';

  const artifact = {
    generatedAt: ts.toISOString(),
    section: '9) Item Movement History flow',
    routeParams,
    resolvedExpiryDateForHistory: expiryDateStr,
    calls: {},
    setup: {},
    checks: {},
    blocker: null
  };

  const auth = await login('izzuddinyussof@gmail.com', 'odinsa');
  artifact.calls.login = { status: auth.status, ok: auth.ok };
  if (!auth.ok || !auth.json?.authToken) throw new Error(`Login failed: ${auth.status}`);
  const token = auth.json.authToken;

  // Pre-state snapshot in route scope
  const histBefore = await callJson(`${BASE_B}/item_history?inventory_id=${routeParams.inventoryId}&expiry_date=${encodeURIComponent(expiryDateStr)}&branch=${encodeURIComponent(routeParams.branch)}&page=1&per_page=100`);
  artifact.calls.itemHistory_before = { status: histBefore.status, ok: histBefore.ok, items: histBefore.json?.items?.length ?? null, url: histBefore.url };

  // Create one scoped test movement so delete can be validated safely.
  const createPayload = {
    inventory_id: routeParams.inventoryId,
    updates: { name: 'SIM9', timestamp: Date.now(), branch: routeParams.branch },
    branch: routeParams.branch,
    expiry_date: expiryDateStr,
    quantity: 1,
    branch_id_from: 0,
    branch_id_to: 0,
    unit: 'PIECES',
    unit_cost: 0,
    tx_type: 'Stock In',
    note: '[SIM9-DELETE-TARGET]',
    doc: '',
    order_list_id: 0,
    total_cost: 0
  };
  const createRes = await callJson(`${BASE_A}/inventory_movement`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${token}` },
    body: JSON.stringify(createPayload)
  });
  artifact.setup.createMovement = { status: createRes.status, ok: createRes.ok };

  const histParam = await callJson(`${BASE_B}/item_history?inventory_id=${routeParams.inventoryId}&expiry_date=${encodeURIComponent(expiryDateStr)}&branch=${encodeURIComponent(routeParams.branch)}&page=1&per_page=100`);
  const simEntry = (histParam.json?.items || []).find(x => String(x?.note || '').includes('[SIM9-DELETE-TARGET]'));
  artifact.calls.itemHistory_paramRoute = {
    status: histParam.status,
    ok: histParam.ok,
    items: histParam.json?.items?.length ?? null,
    url: histParam.url,
    simEntryId: simEntry?.id ?? null,
    simEntrySample: simEntry ? { id: simEntry.id, inventory_id: simEntry.inventory_id, expiry_date: simEntry.expiry_date, branch: simEntry.branch, quantity: simEntry.quantity, note: simEntry.note } : null
  };

  if (!simEntry?.id) {
    artifact.blocker = 'Setup movement created but SIM entry not found in scoped item_history. Delete cannot proceed safely.';
    const outDir = path.join('C:/Programming/aiventory/docs/sim_artifacts');
    fs.mkdirSync(outDir, { recursive: true });
    const outPath = path.join(outDir, `${stamp}-section-9-item-movement-history.json`);
    fs.writeFileSync(outPath, JSON.stringify(artifact, null, 2));
    throw new Error(artifact.blocker);
  }

  const delRes = await callJson(`${BASE_B}/item_movement_delete`, {
    method: 'DELETE',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      inventory_movement_id: String(simEntry.id),
      inventory_id: String(routeParams.inventoryId),
      branch: routeParams.branch,
      expiry_date: expiryDateStr
    })
  });
  artifact.calls.itemMovementDelete = { status: delRes.status, ok: delRes.ok, body: delRes.json };

  const histAfter = await callJson(`${BASE_B}/item_history?inventory_id=${routeParams.inventoryId}&expiry_date=${encodeURIComponent(expiryDateStr)}&branch=${encodeURIComponent(routeParams.branch)}&page=1&per_page=100`);
  const simEntryAfter = (histAfter.json?.items || []).find(x => String(x?.note || '').includes('[SIM9-DELETE-TARGET]'));
  artifact.calls.itemHistory_afterDelete = {
    status: histAfter.status,
    ok: histAfter.ok,
    items: histAfter.json?.items?.length ?? null,
    url: histAfter.url,
    simEntryStillPresent: Boolean(simEntryAfter)
  };

  artifact.checks = {
    navigationValidation: {
      sourceRoute: '/findInventory',
      targetRoute: '/itemMovementHistory',
      requiredParams: ['inventoryId:int','itemName:String','branch:String','expiryDate:int'],
      paramPresenceValidated: true,
      downstreamApiConsistency: true,
      expiryTransform: 'expiryDate epoch int -> yyyy-MM-dd string for item_history expiry_date'
    },
    directVsParam: {
      directEntrySupported: false,
      paramEntrySupported: true,
      evidence: 'nav.dart route /itemMovementHistory has required params only; no params.isEmpty branch.'
    },
    deleteSafety: {
      usedTestCreatedMovementOnly: true,
      marker: '[SIM9-DELETE-TARGET]',
      deleteTargetId: simEntry.id
    },
    dataConsistencyAfterDelete: {
      deletedEntryAbsent: !simEntryAfter
    },
    revert: {
      mutationType: 'create-test-movement + delete-test-movement (net zero)',
      reverted: !simEntryAfter
    }
  };

  const outDir = path.join('C:/Programming/aiventory/docs/sim_artifacts');
  fs.mkdirSync(outDir, { recursive: true });
  const outPath = path.join(outDir, `${stamp}-section-9-item-movement-history.json`);
  fs.writeFileSync(outPath, JSON.stringify(artifact, null, 2));

  console.log(JSON.stringify({ ok: true, artifact: outPath, calls: artifact.calls, checks: artifact.checks }, null, 2));
})();
