const fs = require('fs');
const path = require('path');

const BASE = 'https://xqoc-ewo0-x3u2.s2.xano.io/api:s4bMNy03';

async function postLogin(email, password) {
  const fd = new FormData();
  fd.append('email', email);
  fd.append('password', password);
  const res = await fetch(`${BASE}/auth/login`, { method: 'POST', body: fd });
  const text = await res.text();
  let json;
  try { json = JSON.parse(text); } catch { json = { raw: text }; }
  return { status: res.status, ok: res.ok, json };
}

async function getWithToken(endpoint, token) {
  const res = await fetch(`${BASE}${endpoint}`, {
    method: 'GET',
    headers: { Authorization: `Bearer ${token}` },
  });
  const text = await res.text();
  let json;
  try { json = JSON.parse(text); } catch { json = { raw: text }; }
  return { status: res.status, ok: res.ok, json };
}

async function getNoAuth(endpoint) {
  const res = await fetch(`${BASE}${endpoint}`, { method: 'GET' });
  const text = await res.text();
  let json;
  try { json = JSON.parse(text); } catch { json = { raw: text }; }
  return { status: res.status, ok: res.ok, json };
}

(async () => {
  const startedAt = new Date().toISOString();

  const successLogin = await postLogin('izzuddinyussof@gmail.com', 'odinsa');
  const token = successLogin?.json?.authToken || null;

  let authMe = null;
  let inventory = null;
  let branchList = null;
  let inventoryCategory = null;

  if (token) {
    authMe = await getWithToken('/auth/me', token);
    inventory = await getNoAuth('/inventory');
    branchList = await getNoAuth('/branch_list_basic');
    inventoryCategory = await getNoAuth('/inventory_category_list');
  }

  const wrongEmailLogin = await postLogin('izzuddinyussof+wrong@gmail.com', 'odinsa');

  const report = {
    startedAt,
    baseUrl: BASE,
    successLogin,
    storedVarsFromFlow: {
      token,
      user: authMe?.json || null,
      allInventoryCount: Array.isArray(inventory?.json) ? inventory.json.length : null,
      branchListCount: Array.isArray(branchList?.json) ? branchList.json.length : null,
      inventoryCategoryCount: Array.isArray(inventoryCategory?.json) ? inventoryCategory.json.length : null,
      branchResolvedByLabel: token && authMe?.json?.branch && Array.isArray(branchList?.json)
        ? (branchList.json.find((b) => b?.label === authMe.json.branch) || null)
        : null,
    },
    bootstrapCalls: {
      authMe,
      inventory,
      branchList,
      inventoryCategory,
    },
    negativeCase_wrongEmail: wrongEmailLogin,
  };

  const outDir = 'C:/Programming/aiventory/docs';
  if (!fs.existsSync(outDir)) fs.mkdirSync(outDir, { recursive: true });

  fs.writeFileSync(path.join(outDir, 'SIM_LOGIN_FLOW_LIVE.json'), JSON.stringify(report, null, 2));

  const tokenMasked = token ? `${String(token).slice(0, 10)}...${String(token).slice(-6)}` : null;
  const md = `# SIM_LOGIN_FLOW_LIVE\n\nGenerated: ${new Date().toISOString()}\n\n## 1) Login (valid credentials)\n- status: ${successLogin.status}\n- ok: ${successLogin.ok}\n- has authToken: ${Boolean(token)}\n- token (masked): ${tokenMasked || 'N/A'}\n\n## 2) auth/me using token\n- status: ${authMe?.status ?? 'N/A'}\n- ok: ${authMe?.ok ?? 'N/A'}\n- user branch: ${authMe?.json?.branch ?? 'N/A'}\n- user access: ${authMe?.json?.access ?? 'N/A'}\n\n## 3) Bootstrap GET calls\n- /inventory: status ${inventory?.status ?? 'N/A'}, count ${Array.isArray(inventory?.json) ? inventory.json.length : 'N/A'}\n- /branch_list_basic: status ${branchList?.status ?? 'N/A'}, count ${Array.isArray(branchList?.json) ? branchList.json.length : 'N/A'}\n- /inventory_category_list: status ${inventoryCategory?.status ?? 'N/A'}, count ${Array.isArray(inventoryCategory?.json) ? inventoryCategory.json.length : 'N/A'}\n\n## 4) Wrong email test\n- status: ${wrongEmailLogin.status}\n- ok: ${wrongEmailLogin.ok}\n- response message: ${wrongEmailLogin?.json?.message ?? JSON.stringify(wrongEmailLogin?.json)}\n\n## 5) App flow simulation notes\n- Token was stored in simulated state object and used for auth/me.\n- Derived branch mapping by matching authMe.branch against branch_list_basic.label.\n- Full raw responses are saved in docs/SIM_LOGIN_FLOW_LIVE.json.\n`; 

  fs.writeFileSync(path.join(outDir, 'SIM_LOGIN_FLOW_LIVE.md'), md);

  console.log('Wrote docs/SIM_LOGIN_FLOW_LIVE.json and .md');
})();