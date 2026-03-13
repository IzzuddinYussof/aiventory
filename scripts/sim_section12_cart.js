const fs = require('fs');
const path = require('path');

const AUTH_BASE = 'https://xqoc-ewo0-x3u2.s2.xano.io/api:s4bMNy03';
const CARO_BASE = 'https://xqoc-ewo0-x3u2.s2.xano.io/api:s4bMNy03';

const EMAIL = 'izzuddinyussof@gmail.com';
const PASSWORD = 'odinsa';

function toMytStamp(d = new Date()) {
  const p = new Intl.DateTimeFormat('sv-SE', {
    timeZone: 'Asia/Kuala_Lumpur',
    year: 'numeric', month: '2-digit', day: '2-digit',
    hour: '2-digit', minute: '2-digit', second: '2-digit',
    hour12: false
  }).formatToParts(d).reduce((a, x) => (a[x.type] = x.value, a), {});
  return `${p.year}${p.month}${p.day}-${p.hour}${p.minute}${p.second}`;
}

async function login() {
  const fd = new FormData();
  fd.append('email', EMAIL);
  fd.append('password', PASSWORD);
  const res = await fetch(`${AUTH_BASE}/auth/login`, { method: 'POST', body: fd });
  const text = await res.text();
  let json; try { json = JSON.parse(text); } catch { json = { raw: text }; }
  return { status: res.status, json };
}

async function getJson(url, token) {
  const headers = token ? { Authorization: `Bearer ${token}` } : {};
  const res = await fetch(url, { method: 'GET', headers });
  const text = await res.text();
  let json; try { json = JSON.parse(text); } catch { json = { raw: text }; }
  return { status: res.status, json };
}

(async () => {
  const now = new Date();
  const stamp = toMytStamp(now);

  const auth = await login();
  const token = auth?.json?.authToken || null;

  const carousellDefault = await getJson(`${CARO_BASE}/inventory_carousell?inventory_ids=[]&name=&category=`, token);

  // branch_id=2 from current simulated user branch resolution (Dentabay Bangi)
  const movementInProgress = await getJson(`${CARO_BASE}/inventory_carousell_movement?branch_id=2&status=In%20Progress`, token);

  const rows = Array.isArray(carousellDefault.json) ? carousellDefault.json : [];
  const selected = rows[0] || null;

  const artifact = {
    generatedAt: now.toISOString(),
    section: '12) Cart flow',
    mode: 'blocked-no-mutation',
    calls: {
      authLogin: { status: auth.status },
      carousellDefault: {
        status: carousellDefault.status,
        count: rows.length,
        sampleTopIds: rows.slice(0, 8).map(x => x?.id).filter(v => v != null)
      },
      movementInProgress: {
        status: movementInProgress.status,
        branchId: 2,
        count: Array.isArray(movementInProgress.json) ? movementInProgress.json.length : null,
        sampleTopIds: Array.isArray(movementInProgress.json) ? movementInProgress.json.slice(0, 8).map(x => x?.id).filter(v => v != null) : []
      }
    },
    selectedItem: selected ? {
      id: selected.id,
      inventoryId: selected.inventory_id,
      itemName: selected.item_name,
      branch: selected.branch,
      branchId: selected.branch_id,
      unit: selected.unit,
      unitCost: selected.unit_cost,
      availableQuantity: selected.quantity,
      type: selected.type,
      remark: selected.remark,
      imageUrl: selected.image_url
    } : null,
    routeContractValidation: {
      sourceRoute: '/carousell',
      targetRoute: '/cart',
      sourcePushNamedHasParams: true,
      targetRequiresParams: [
        'itemName:String','branch:String','image:String','itemID:String','branchID:int','carousellID:int','unit:String','price:double','availableQuantity:double','remark:String','inventoryId:int','type:String','search:String','category:String'
      ],
      paramTypesConsistentWithSource: true,
      downstreamPayloadFromParams: {
        branch_id_from: 'type==Selling ? branchID : FFAppState.branchIdUser',
        branch_id_to: 'type==Selling ? FFAppState.branchIdUser : branchID',
        inventory_carousell_id: 'carousellID',
        inventory_id: 'inventoryId',
        type: 'type'
      }
    },
    directVsParam: {
      directEntrySupported: false,
      paramEntrySupported: true,
      evidence: '/cart route in nav.dart has no params.isEmpty branch; CarousellWidget pushNamed to Cart always passes queryParameters'
    },
    blocker: {
      reason: 'Exact pre-state revert for POST /inventory_carousell_movement is not currently possible with app-exposed contracts (no delete endpoint; PUT only mutates status/flags and cannot restore absence of newly created row).',
      skippedMutation: true,
      requiredByRule: 'Rule 5 exact pre-state revert in same run'
    }
  };

  const outPath = path.join('C:/Programming/aiventory/docs/sim_artifacts', `${stamp}-section-12-cart-flow.json`);
  fs.mkdirSync(path.dirname(outPath), { recursive: true });
  fs.writeFileSync(outPath, JSON.stringify(artifact, null, 2));

  console.log(JSON.stringify({ outPath, status: 'ok' }));
})();
