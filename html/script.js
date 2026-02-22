let uiToken = null;
let uiText = {};
let requestCounter = 0;
let currentMode = null;
let currentQuery = '';
let playersOffset = 0;
let historyOffset = 0;
let selectedPlayer = null;
let pendingBan = null;

function nextRequestId() {
    requestCounter += 1;
    return `req_${Date.now()}_${requestCounter}`;
}

function post(route, data) {
    return fetch(`https://${GetParentResourceName()}/${route}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: JSON.stringify(data || {})
    }).then((res) => res.json());
}

function setStatus(elementId, message, type) {
    const el = document.getElementById(elementId);
    el.textContent = message || '';
    el.classList.remove('error', 'success');
    if (type) {
        el.classList.add(type);
    }
}

function clearStatuses() {
    setStatus('page1-status', '');
    setStatus('page2-status', '');
    setStatus('page3-status', '');
    setStatus('page4-status', '');
    setStatus('page5-status', '');
}

function showPage(pageNumber) {
    [1, 2, 3, 4, 5].forEach((p) => {
        document.getElementById(`page-${p}`).style.display = p === pageNumber ? 'block' : 'none';
    });
}

function closeMenu() {
    post('closeMenu', {});
    document.getElementById('bansql-menu').style.display = 'none';
}

function getHideSensitive() {
    return document.getElementById('toggle-sensitive').checked;
}

function formatSensitiveDetails(entry) {
    const lines = [];
    if (entry.license) lines.push(`license: ${entry.license}`);
    if (entry.steamid) lines.push(`steamid: ${entry.steamid}`);
    if (entry.fivemid) lines.push(`fivemid: ${entry.fivemid}`);
    if (entry.liveid) lines.push(`liveid: ${entry.liveid}`);
    if (entry.xblid) lines.push(`xblid: ${entry.xblid}`);
    if (entry.discord) lines.push(`discord: ${entry.discord}`);
    if (entry.playerip) lines.push(`ip: ${entry.playerip}`);
    if (entry.tokens) lines.push(`tokens: ${entry.tokens}`);
    return lines.join(' | ');
}

function renderPlayers(results, append = false) {
    const list = document.getElementById('results-list');
    if (!append) {
        list.innerHTML = '';
    }

    if ((!results || results.length === 0) && !append) {
        list.innerHTML = `<div class="empty">${uiText.noResults || 'No results'}</div>`;
        return;
    }

    (results || []).forEach((entry) => {
        const card = document.createElement('div');
        card.className = 'result-card';

        const details = getHideSensitive() ? '' : `<div class="result-details">${formatSensitiveDetails(entry)}</div>`;
        card.innerHTML = `
            <div class="result-main">
                <div class="result-date">${entry.last_modified_label || 'N/A'}</div>
                <div class="result-name">${entry.playername || 'N/A'}</div>
                ${details}
            </div>
            <div class="result-actions">
                <button class="btn btn-danger">${uiText.banButton || 'Ban'}</button>
            </div>
        `;

        const banBtn = card.querySelector('button');
        banBtn.addEventListener('click', (event) => {
            event.stopPropagation();
            selectedPlayer = entry;
            openPage4();
        });

        list.appendChild(card);
    });
}

function renderHistory(results, append = false) {
    const list = document.getElementById('history-list');
    if (!append) {
        list.innerHTML = '';
    }

    if ((!results || results.length === 0) && !append) {
        list.innerHTML = `<div class="empty">${uiText.noResults || 'No results'}</div>`;
        return;
    }

    (results || []).forEach((entry) => {
        const card = document.createElement('div');
        card.className = 'result-card';

        const statusText = entry.isActive ? (uiText.stillBanned || 'Toujours banni') : (uiText.notBanned || 'Non banni');
        const statusClass = entry.isActive ? 'active' : 'inactive';

        card.innerHTML = `
            <div class="result-main">
                <div class="result-date">${entry.timeat_label || 'N/A'}</div>
                <div class="result-name">${entry.targetplayername || 'N/A'}</div>
                <div class="result-details">${entry.reason || ''} | by ${entry.sourceplayername || 'N/A'}</div>
            </div>
            <div class="result-actions">
                <span class="history-status ${statusClass}">${statusText}</span>
                ${entry.isActive ? `<button class="btn btn-secondary">${uiText.unbanButton || 'Déban'}</button>` : ''}
            </div>
        `;

        const unbanBtn = card.querySelector('button');
        if (unbanBtn) {
            unbanBtn.addEventListener('click', (event) => {
                event.stopPropagation();
                setStatus('page3-status', uiText.loading || 'Loading...');
                post('unbanLicense', { token: uiToken, license: entry.license });
            });
        }

        list.appendChild(card);
    });
}

function loadPlayers(reset) {
    const requestId = nextRequestId();
    if (reset) {
        playersOffset = 0;
    }

    setStatus('page2-status', uiText.loading || 'Loading...');

    if (currentMode === 'search') {
        post('searchByName', {
            token: uiToken,
            requestId,
            query: currentQuery,
            offset: playersOffset,
            hideSensitive: getHideSensitive()
        });
    } else {
        post('loadRecentPlayers', {
            token: uiToken,
            requestId,
            offset: playersOffset,
            hideSensitive: getHideSensitive()
        });
    }
}

function loadHistory(reset) {
    const requestId = nextRequestId();
    if (reset) {
        historyOffset = 0;
    }

    setStatus('page3-status', uiText.loading || 'Loading...');
    post('loadBanHistory', {
        token: uiToken,
        requestId,
        offset: historyOffset
    });
}

function openPage4() {
    if (!selectedPlayer) {
        return;
    }

    const details = getHideSensitive()
        ? ''
        : `<div class="result-details">${formatSensitiveDetails(selectedPlayer)}</div>`;

    document.getElementById('selected-player').innerHTML = `
        <div class="result-date">${selectedPlayer.last_modified_label || 'N/A'}</div>
        <div class="result-name">${selectedPlayer.playername || 'N/A'}</div>
        ${details}
    `;
    clearStatuses();
    showPage(4);
}

function openPage5() {
    const permanent = document.getElementById('ban-permanent').checked;
    const reason = document.getElementById('ban-reason').value.trim();
    const days = Number(document.getElementById('ban-days').value);

    if (!selectedPlayer) {
        setStatus('page4-status', uiText.invalidId || 'Invalid player', 'error');
        return;
    }

    if (!permanent && (Number.isNaN(days) || days < 0 || days >= 365)) {
        setStatus('page4-status', uiText.invalidTime || 'Invalid time', 'error');
        return;
    }

    pendingBan = {
        playerId: selectedPlayer.id,
        playername: selectedPlayer.playername,
        reason: reason || uiText.noReason || 'No reason',
        permanent,
        days: permanent ? 0 : days
    };

    document.getElementById('confirm-box').innerHTML = `
        <div class="result-name">${pendingBan.playername || 'N/A'}</div>
        ${pendingBan.permanent ? `<div style='display:flex;align-items:center;justify-content:flex-start;gap:6px;margin-top:8px;'><input type='checkbox' checked disabled style='margin:0;'><span>Permanent</span></div>` : ''}
        <div class="result-details">
            ID: ${pendingBan.playerId}<br>
            Type: ${pendingBan.permanent ? '' : `${pendingBan.days} jour(s)`}<br>
            Raison: ${pendingBan.reason}
        </div>
    `;

    clearStatuses();
    showPage(5);
}

document.getElementById('close-menu').addEventListener('click', closeMenu);

document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape') {
        closeMenu();
    }
});

document.getElementById('search-btn').addEventListener('click', () => {
    const value = document.getElementById('search-input').value.trim();
    if (!value) {
        setStatus('page1-status', uiText.invalidName || 'Name required', 'error');
        return;
    }

    currentMode = 'search';
    currentQuery = value;
    showPage(2);
    loadPlayers(true);
});

document.getElementById('recent-btn').addEventListener('click', () => {
    currentMode = 'recent';
    currentQuery = '';
    showPage(2);
    loadPlayers(true);
});

document.getElementById('history-btn').addEventListener('click', () => {
    showPage(3);
    loadHistory(true);
});

document.getElementById('results-more-btn').addEventListener('click', () => loadPlayers(false));
document.getElementById('history-more-btn').addEventListener('click', () => loadHistory(false));
document.getElementById('results-back-btn').addEventListener('click', () => showPage(1));
document.getElementById('history-back-btn').addEventListener('click', () => showPage(1));
document.getElementById('page4-back-btn').addEventListener('click', () => showPage(2));
document.getElementById('page5-back-btn').addEventListener('click', () => showPage(4));
document.getElementById('to-confirm-btn').addEventListener('click', openPage5);

document.getElementById('confirm-ban-btn').addEventListener('click', () => {
    if (!pendingBan) {
        return;
    }

    setStatus('page5-status', uiText.loading || 'Loading...');
    post('submitBan', {
        token: uiToken,
        playerId: pendingBan.playerId,
        days: pendingBan.days,
        permanent: pendingBan.permanent,
        reason: pendingBan.reason
    });
});

document.getElementById('ban-permanent').addEventListener('change', (event) => {
    document.getElementById('days-group').style.display = event.target.checked ? 'none' : 'block';
});

document.getElementById('toggle-sensitive').addEventListener('change', () => {
    if (currentMode === 'search' || currentMode === 'recent') {
        loadPlayers(true);
    }
});

window.addEventListener('message', (event) => {
    const data = event.data || {};

    if (data.action === 'openMenu') {
        uiToken = data.token || null;
        uiText = data.texts || {};

        document.getElementById('menu-title').textContent = uiText.title || 'BanSql Admin';
        document.getElementById('toggle-sensitive-label').textContent = uiText.hideSensitive || 'Masqué les informations confidentiel';
        document.getElementById('page1-title').textContent = uiText.page1Title || 'Choix de l\'action';
        document.getElementById('search-by-name-title').textContent = uiText.searchByName || 'Recherche par steamname';
        document.getElementById('search-input').placeholder = uiText.searchPlaceholder || 'Steamname...';
        document.getElementById('search-btn').textContent = uiText.searchButton || 'Search';
        document.getElementById('recent-btn').textContent = uiText.lastConnectedButton || 'Affiché les derniere joueurs connecté';
        document.getElementById('history-btn').textContent = uiText.historyButton || 'Affichage de l\'historique de ban';
        document.getElementById('results-title').textContent = uiText.page2Title || 'Résultats';
        document.getElementById('results-more-btn').textContent = uiText.continueSearch || 'Continuer les recherche';
        document.getElementById('history-title').textContent = uiText.page3Title || 'Historique de ban';
        document.getElementById('history-more-btn').textContent = uiText.continueSearch || 'Continuer les recherche';
        document.getElementById('ban-args-title').textContent = uiText.page4Title || 'Arguments du ban';
        document.getElementById('label-days').textContent = uiText.dayLabel || 'Nombre de jours';
        document.getElementById('permanent-label').textContent = uiText.permanentLabel || 'Permanent';
        document.getElementById('label-reason').textContent = uiText.reasonLabel || 'Raison';
        document.getElementById('to-confirm-btn').textContent = uiText.nextButton || 'Continuer';
        document.getElementById('confirm-title').textContent = uiText.page5Title || 'Confirmation';
        document.getElementById('confirm-ban-btn').textContent = uiText.confirmButton || 'Confirmer';
        document.getElementById('results-back-btn').textContent = uiText.backButton || 'Retour';
        document.getElementById('history-back-btn').textContent = uiText.backButton || 'Retour';
        document.getElementById('page4-back-btn').textContent = uiText.backButton || 'Retour';
        document.getElementById('page5-back-btn').textContent = uiText.backButton || 'Retour';

        document.getElementById('toggle-sensitive').checked = true;
        document.getElementById('ban-permanent').checked = false;
        document.getElementById('days-group').style.display = 'block';
        document.getElementById('ban-days').value = 0;
        document.getElementById('ban-reason').value = '';
        document.getElementById('search-input').value = '';
        document.getElementById('results-list').innerHTML = '';
        document.getElementById('history-list').innerHTML = '';
        document.getElementById('results-more-btn').style.display = 'none';
        document.getElementById('history-more-btn').style.display = 'none';

        currentMode = null;
        currentQuery = '';
        playersOffset = 0;
        historyOffset = 0;
        selectedPlayer = null;
        pendingBan = null;
        clearStatuses();
        showPage(1);

        document.getElementById('bansql-menu').style.display = 'flex';
    }

    if (data.action === 'closeMenu') {
        document.getElementById('bansql-menu').style.display = 'none';
    }

    if (data.action === 'playersResult') {
        if (data.success === false) {
            setStatus('page2-status', data.message || 'Erreur', 'error');
            return;
        }

        const append = playersOffset > 0;
        renderPlayers(data.results || [], append);
        playersOffset = Number(data.nextOffset || 0);
        document.getElementById('results-more-btn').style.display = data.hasMore ? 'inline-block' : 'none';
        setStatus('page2-status', '');
    }

    if (data.action === 'historyResult') {
        if (data.success === false) {
            setStatus('page3-status', data.message || 'Erreur', 'error');
            return;
        }

        const append = historyOffset > 0;
        renderHistory(data.results || [], append);
        historyOffset = Number(data.nextOffset || 0);
        document.getElementById('history-more-btn').style.display = data.hasMore ? 'inline-block' : 'none';
        setStatus('page3-status', '');
    }

    if (data.action === 'banResult') {
        if (data.success === false) {
            setStatus('page5-status', data.message || 'Erreur', 'error');
            return;
        }
        setStatus('page5-status', data.message || 'Ban effectué', 'success');
    }

    if (data.action === 'unbanResult') {
        if (data.success === false) {
            setStatus('page3-status', data.message || 'Erreur', 'error');
            return;
        }
        setStatus('page3-status', data.message || 'Déban effectué', 'success');
        loadHistory(true);
    }
});