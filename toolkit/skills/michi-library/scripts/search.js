// The library's search box: a dropdown of matching sections, from search-index.js, as the reader types.
// A result for a document built for several roles opens the copy for this page's role when there is one.
(function () {
  const MAX_RESULTS = 10;
  const EXCERPT_LENGTH = 120;
  const LEAD_IN = 40;
  const ROLE_LABELS = { shared: 'For everyone', More: 'More' };

  const box = document.querySelector('.search');
  if (!box || !window.MiniSearch || !Array.isArray(window.LIBRARY_SEARCH)) {
    return;
  }
  const input = box.querySelector('input');
  const list = box.querySelector('.search-results');
  const root = box.dataset.root || '';
  const role = box.dataset.role || '';
  const entries = window.LIBRARY_SEARCH.map((entry, index) => ({ ...entry, id: index }));
  const engine = new window.MiniSearch({
    fields: ['title', 'section', 'text'],
    searchOptions: { prefix: true, fuzzy: 0.2, combineWith: 'AND', boost: { title: 2, section: 1.5 } },
  });
  engine.addAll(entries);
  let selected = -1;

  const roleLabel = (name) => ROLE_LABELS[name] || 'For ' + name + 's';
  const opensCopy = (entry) => Boolean(entry.copies && entry.copies[role]);

  function targetOf(entry) {
    const page = opensCopy(entry) ? entry.copies[role] : entry.page;
    return root + page + (entry.anchor ? '#' + entry.anchor : '');
  }

  // The excerpt starts a little before the first match, at a word, and ends at a word.
  function excerptOf(text, terms) {
    const lower = text.toLowerCase();
    const at = terms.map((term) => lower.indexOf(term)).filter((index) => index >= 0).sort((a, b) => a - b)[0] || 0;
    let start = Math.max(0, at - LEAD_IN);
    if (start > 0) {
      const space = text.indexOf(' ', start);
      start = space >= 0 && space < at ? space + 1 : at;
    }
    let end = Math.min(text.length, start + EXCERPT_LENGTH);
    if (end < text.length) {
      const space = text.lastIndexOf(' ', end);
      end = space > start ? space : end;
    }
    return (start > 0 ? '… ' : '') + text.slice(start, end) + (end < text.length ? ' …' : '');
  }

  function resultItem(entry, terms, index) {
    const item = document.createElement('li');
    item.setAttribute('role', 'presentation');
    const link = document.createElement('a');
    link.href = targetOf(entry);
    link.id = 'library-search-option-' + index;
    link.setAttribute('role', 'option');
    link.setAttribute('aria-selected', 'false');
    link.dataset.testid = 'library-search-result';
    const heading = document.createElement('strong');
    heading.textContent = entry.section && entry.section !== entry.title ? entry.title + ' · ' + entry.section : entry.title;
    const where = document.createElement('small');
    where.textContent = roleLabel(opensCopy(entry) ? role : entry.role);
    const excerpt = document.createElement('small');
    excerpt.textContent = excerptOf(entry.text || '', terms);
    link.append(heading, where, excerpt);
    link.addEventListener('click', close);
    item.append(link);
    return item;
  }

  function open() {
    list.hidden = false;
    input.setAttribute('aria-expanded', 'true');
  }

  function close() {
    list.hidden = true;
    selected = -1;
    input.setAttribute('aria-expanded', 'false');
    input.removeAttribute('aria-activedescendant');
  }

  function show(query) {
    list.replaceChildren();
    selected = -1;
    input.removeAttribute('aria-activedescendant');
    if (!query.trim()) {
      close();
      return;
    }
    const results = engine.search(query).slice(0, MAX_RESULTS);
    if (results.length === 0) {
      const empty = document.createElement('li');
      empty.className = 'search-empty';
      empty.setAttribute('role', 'presentation');
      empty.textContent = 'No matches.';
      list.append(empty);
    }
    results.forEach((result, index) => list.append(resultItem(entries[result.id], result.terms, index)));
    open();
  }

  function select(index) {
    const options = list.querySelectorAll('[role="option"]');
    if (options.length === 0) {
      return;
    }
    selected = (index + options.length) % options.length;
    options.forEach((option, position) => option.setAttribute('aria-selected', String(position === selected)));
    input.setAttribute('aria-activedescendant', options[selected].id);
    options[selected].scrollIntoView({ block: 'nearest' });
  }

  function onKey(event) {
    if (event.isComposing) {
      return;
    }
    const options = list.querySelectorAll('[role="option"]');
    if (event.key === 'ArrowDown') {
      event.preventDefault();
      select(selected + 1);
    } else if (event.key === 'ArrowUp') {
      event.preventDefault();
      select(selected - 1);
    } else if (event.key === 'Enter' && options.length > 0) {
      event.preventDefault();
      const target = options[Math.max(selected, 0)].href;
      close();
      window.location.href = target;
    } else if (event.key === 'Escape') {
      close();
      input.blur();
    } else if (event.key === 'Tab') {
      close();
    }
  }

  input.addEventListener('input', () => show(input.value));
  input.addEventListener('keydown', onKey);
  input.addEventListener('focus', () => input.value && show(input.value));
  document.addEventListener('click', (event) => {
    if (!box.contains(event.target)) {
      close();
    }
  });
  window.addEventListener('hashchange', close);
  box.hidden = false;
})();
