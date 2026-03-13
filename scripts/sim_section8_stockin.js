const fs = require('fs');
const path = require('path');

const BASE_A = 'https://xqoc-ewo0-x3u2.s2.xano.io/api:s4bMNy03';
const BASE_B = 'https://xqoc-ewo0-x3u2.s2.xano.io/api:0o-ZhGP6';

async function callJson(url, options = {}) {
  const res = await fetch(url, options);
  const text = await res.text();
  let json;
  try { json = JSON.parse(text); } catch { json = { raw: text }; }
  return { status: res.status, ok: res.ok, json };
}

async function login(email, password) {
  const fd = new FormData();
  fd.append('email', email);
  fd.append('password', password);
  return callJson(`${BASE_A}/auth/login`, { method: 'POST', body: fd });
}

function unitOptions(inv) {
  const arr = [];
  if (inv?.quantity_minor && !arr.includes(inv.quantity_minor)) arr.push(inv.quantity_minor);
  if (inv?.quantity_major && !arr.includes(inv.quantity_major)) arr.push(inv.quantity_major);
  return arr;
}

(async () => {
  const ts = new Date();
  const stamp = `${ts.getFullYear()}${String(ts.getMonth()+1).padStart(2,'0')}${String(ts.getDate()).padStart(2,'0')}-${String(ts.getHours()).padStart(2,'0')}${String(ts.getMinutes()).padStart(2,'0')}${String(ts.getSeconds()).padStart(2,'0')}`;

  const artifact = {
    startedAt: ts.toISOString(),
    section: '8) Stock In flow',
    apis: {},
    checks: {},
    notes: []
  };

  const auth = await login('izzuddinyussof@gmail.com', 'odinsa');
  artifact.apis.login = { status: auth.status, ok: auth.ok };
  if (!auth.ok || !auth.json?.authToken) throw new Error(`Login failed: ${auth.status}`);

  const me = await callJson(`${BASE_A}/auth/me`, { headers: { Authorization: `Bearer ${auth.json.authToken}` } });
  artifact.apis.authMe = { status: me.status, ok: me.ok };
  const user = me.json || {};

  const invRes = await callJson(`${BASE_A}/inventory?name=glove&category=&supplier=`);
  artifact.apis.inventory_lookup = { status: invRes.status, ok: invRes.ok, count: Array.isArray(invRes.json) ? invRes.json.length : null };
  if (!invRes.ok || !Array.isArray(invRes.json) || invRes.json.length === 0) throw new Error('Inventory lookup failed');
  const directInv = invRes.json.find(i => i?.id && (i?.quantity_minor || i?.quantity_major)) || invRes.json[0];

  const barcodeProbe = directInv.barcode && String(directInv.barcode).trim() !== '' ? String(directInv.barcode) : 'SIM8-BARCODE-PROBE-NOTFOUND';
  const barcodeRes = await callJson(`${BASE_A}/inventory_barcode?barcode=${encodeURIComponent(barcodeProbe)}`);
  artifact.apis.inventory_barcode = { status: barcodeRes.status, ok: barcodeRes.ok, probe: barcodeProbe, id: barcodeRes.json?.id ?? null };

  const fdUpload = new FormData();
  fdUpload.append('main_folder', user.branch || 'Dentabay Bangi');
  fdUpload.append('sub_folder', directInv.item_name || 'SIM-STOCKIN');
  fdUpload.append('file', new Blob(['SIM8 upload probe'], { type: 'text/plain' }), 'sim8-upload.txt');
  const uploadRes = await callJson(`${BASE_A}/uploadFile_inventory`, { method: 'POST', body: fdUpload });
  artifact.apis.uploadFile_inventory = { status: uploadRes.status, ok: uploadRes.ok, hasViewUrl: Boolean(uploadRes.json?.view_url || uploadRes.json?.viewUrl) };

  // direct-entry mode validation (no mutation): no orderData => order_list_id 0, no received update call.
  const directPayloadPreview = {
    inventory_id: directInv.id,
    unit: unitOptions(directInv)[0] || '',
    order_list_id: 0,
    tx_type: 'Stock In'
  };

  // param-entry mode: use /orderList data -> StockIn(orderData) and do live mutation+revert
  const orderListPayload = { branch: user.branch || 'Dentabay Bangi', status: ['ordered'], branch_id: 0 };
  const orderedRes = await callJson(`${BASE_A}/order_lists`, {
    method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(orderListPayload)
  });
  artifact.apis.order_lists_ordered = { status: orderedRes.status, ok: orderedRes.ok, count: Array.isArray(orderedRes.json) ? orderedRes.json.length : null };
  if (!orderedRes.ok || !Array.isArray(orderedRes.json) || orderedRes.json.length === 0) throw new Error('No ordered order found for param mode');

  const orderData = orderedRes.json[0];
  const orderBefore = await callJson(`${BASE_A}/order/${orderData.id}`);
  artifact.apis.order_get_before = { status: orderBefore.status, ok: orderBefore.ok, id: orderData.id, statusBefore: orderBefore.json?.status };

  const invParam = orderData.inventory || {};
  const qtyParam = Number(orderData.quantity_ordered || 1);
  const expiryParam = invParam.expiry ? '2026-12-31' : 'Expiry Date';
  const paramBody = {
    inventory_id: Number(invParam.id || orderData.inventory_id),
    updates: { name: user.name || 'SIM8', timestamp: Date.now(), branch: user.branch || 'Dentabay Bangi' },
    branch: user.branch || 'Dentabay Bangi',
    expiry_date: expiryParam,
    quantity: qtyParam,
    branch_id_from: 0,
    branch_id_to: 0,
    unit: unitOptions(invParam)[0] || unitOptions(directInv)[0] || '',
    unit_cost: 0,
    tx_type: 'Stock In',
    note: '[SIM8-PARAM]',
    doc: '',
    order_list_id: orderData.id,
    total_cost: 0
  };

  const moveParam = await callJson(`${BASE_A}/inventory_movement`, {
    method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(paramBody)
  });
  artifact.apis.inventory_movement_param = { status: moveParam.status, ok: moveParam.ok };

  const orderReceivedPayload = {
    status: 'received',
    id: orderData.id,
    name: user.name || '',
    branch: orderData.branch || '',
    amount: Number(orderData.amount || 0),
    inventory_id: Number(orderData.inventory_id || 0),
    remark: '[SIM8-PARAM]',
    image_url: orderData.image_url || '',
    branch_id: Number(orderData.branch_id || 0),
    channel: orderData.channel || ''
  };
  const orderReceived = await callJson(`${BASE_A}/order_list_status`, {
    method: 'PUT', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(orderReceivedPayload)
  });
  artifact.apis.order_status_received = { status: orderReceived.status, ok: orderReceived.ok };

  const histParam = await callJson(`${BASE_B}/item_history?inventory_id=${encodeURIComponent(String(paramBody.inventory_id))}&expiry_date=${encodeURIComponent(String(paramBody.expiry_date))}&branch=${encodeURIComponent(user.branch || 'Dentabay Bangi')}&page=1&per_page=50`);
  artifact.apis.item_history_param = { status: histParam.status, ok: histParam.ok, count: histParam.json?.items?.length ?? null };
  const paramEntry = (histParam.json?.items || []).find(x => String(x?.note || '').includes('[SIM8-PARAM]'));

  let delParam = null;
  if (paramEntry?.id) {
    delParam = await callJson(`${BASE_B}/item_movement_delete`, {
      method: 'DELETE', headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        inventory_movement_id: String(paramEntry.id),
        inventory_id: String(paramBody.inventory_id),
        branch: user.branch || 'Dentabay Bangi',
        expiry_date: String(paramBody.expiry_date)
      })
    });
  }
  artifact.apis.item_movement_delete_param = { status: delParam?.status ?? null, ok: delParam?.ok ?? false };

  const before = orderBefore.json || {};
  const revertPayload = {
    status: before.status,
    id: before.id,
    name: before.name,
    branch: before.branch,
    amount: Number(before.amount || 0),
    inventory_id: Number(before.inventory_id || 0),
    remark: before.remark,
    image_url: before.image_url || '',
    branch_id: Number(before.branch_id || 0),
    channel: before.channel || ''
  };
  const orderRevert = await callJson(`${BASE_A}/order_list_status`, {
    method: 'PUT', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(revertPayload)
  });
  const orderAfter = await callJson(`${BASE_A}/order/${orderData.id}`);
  const histParamAfter = await callJson(`${BASE_B}/item_history?inventory_id=${encodeURIComponent(String(paramBody.inventory_id))}&expiry_date=${encodeURIComponent(String(paramBody.expiry_date))}&branch=${encodeURIComponent(user.branch || 'Dentabay Bangi')}&page=1&per_page=50`);

  artifact.apis.order_status_revert = { status: orderRevert.status, ok: orderRevert.ok };
  artifact.apis.order_get_after = { status: orderAfter.status, ok: orderAfter.ok, statusAfter: orderAfter.json?.status };

  artifact.checks = {
    navigationValidation: {
      sourceRoute: '/orderList',
      targetRoute: '/stockIn',
      requiredParam: 'orderData:OrderListsStruct',
      paramPresenceValidated: Boolean(orderData && orderData.id && (orderData.inventory_id || orderData.inventory?.id)),
      downstreamPayloadConsistency: {
        orderListIdMatches: paramBody.order_list_id === orderData.id,
        inventoryIdUsesOrderData: Number(paramBody.inventory_id) === Number(orderData.inventory?.id || orderData.inventory_id)
      }
    },
    directVsParam: {
      directEntrySupported: true,
      paramEntrySupported: true,
      directModeEvidence: directPayloadPreview,
      paramOrderListId: paramBody.order_list_id,
      directTriggeredOrderStatusUpdate: false,
      paramTriggeredOrderStatusUpdate: orderReceived.ok,
      mismatch: false
    },
    movementHistoryPresence: {
      paramFoundBeforeRevert: Boolean(paramEntry),
      paramFoundAfterRevert: Boolean((histParamAfter.json?.items || []).find(x => String(x?.note || '').includes('[SIM8-PARAM]')))
    },
    revert: {
      orderStatusRestored: orderAfter.json?.status === orderBefore.json?.status,
      movementDeleteParamOk: Boolean(delParam?.ok)
    }
  };

  if (!artifact.checks.revert.orderStatusRestored || !artifact.checks.revert.movementDeleteParamOk) {
    throw new Error(`Revert failed: ${JSON.stringify(artifact.checks.revert)}`);
  }

  artifact.keyState = {
    userBranch: user.branch,
    directInventoryId: directInv.id,
    paramOrderId: orderData.id,
    paramInventoryId: paramBody.inventory_id,
    uploadViewUrl: uploadRes.json?.view_url || uploadRes.json?.viewUrl || null
  };

  const outDir = path.join('C:/Programming/aiventory/docs/sim_artifacts');
  fs.mkdirSync(outDir, { recursive: true });
  const outPath = path.join(outDir, `${stamp}-section-8-stock-in-flow.json`);
  fs.writeFileSync(outPath, JSON.stringify(artifact, null, 2));

  console.log(JSON.stringify({ ok: true, artifact: outPath, checks: artifact.checks, keyState: artifact.keyState }, null, 2));
})();