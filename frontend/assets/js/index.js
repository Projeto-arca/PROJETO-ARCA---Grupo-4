function logar() {
    let usuario = document.getElementById('usuario').value;
    let senha = document.getElementById('senha').value;

    if (usuario === 'tutor' && senha === '123456') {
        window.location.href = 'frontend/pages/tutor/dashboard.html';
    } else if (usuario === 'candidato' && senha === 'cand!098') {
        window.location.href = 'frontend/pages/candidato/dashboard.html';
    } else if (usuario === 'ong' && senha === 'ong$-135') {
        window.location.href = 'frontend/pages/ong/dashboard.html';
    } else if (usuario === 'prefeitura' && senha === 'pref@456') {
        window.location.href = 'frontend/pages/prefeitura/dashboard.html';
    } else {
        alert('Usuário ou senha incorretos. Tente novamente.');
    }
}
