/* Per-user auth continuity for existing Flutter web releases. No shared credentials. */
(function installInventorySessionTransport(window) {
  'use strict';
  if (window.__inventorySessionTransportV1) return;
  function token() {
    for (const key of ['flutter.ff_token', 'ff_token']) {
      try {
        const raw = window.localStorage.getItem(key);
        if (!raw) continue;
        let value;
        try { value = JSON.parse(raw); } catch (_) { value = raw; }
        if (typeof value === 'string' && value.trim()) return value.trim();
      } catch (_) { /* Storage unavailable: preserve the normal auth failure. */ }
    }
    return '';
  }
  function protectedUrl(value) {
    try {
      const u = new URL(value, window.location.href);
      return u.protocol === 'https:' && u.hostname === 'xqoc-ewo0-x3u2.s2.xano.io' &&
        /^\/api:(s4bMNy03|0o-ZhGP6)\//.test(u.pathname) &&
        !/^\/api:[^/]+\/auth\/(login|signup)(\/|$)/.test(u.pathname);
    } catch (_) { return false; }
  }
  function bearer(value) { return /^Bearer\s+/i.test(value) ? value : 'Bearer ' + value; }
  if (typeof window.fetch === 'function') {
    const original = window.fetch.bind(window);
    window.fetch = function (input, options) {
      const url = typeof input === 'string' || input instanceof URL ? String(input) : input && input.url;
      const value = protectedUrl(url) ? token() : '';
      if (!value) return original(input, options);
      const headers = new Headers((options && options.headers) || (input && input.headers) || {});
      if (headers.has('Authorization')) return original(input, options);
      headers.set('Authorization', bearer(value));
      return original(input, { ...(options || {}), headers });
    };
  }
  if (window.XMLHttpRequest) {
    const proto = window.XMLHttpRequest.prototype;
    const open = proto.open, setHeader = proto.setRequestHeader, send = proto.send;
    const requests = new WeakMap();
    proto.open = function (method, url) { requests.set(this, { url: String(url), auth: false }); return open.apply(this, arguments); };
    proto.setRequestHeader = function (name, value) {
      const state = requests.get(this);
      if (state && String(name).toLowerCase() === 'authorization') state.auth = true;
      return setHeader.apply(this, arguments);
    };
    proto.send = function () {
      const state = requests.get(this);
      const value = state && !state.auth && protectedUrl(state.url) ? token() : '';
      if (value) setHeader.call(this, 'Authorization', bearer(value));
      return send.apply(this, arguments);
    };
  }
  window.__inventorySessionTransportV1 = true;
})(window);
