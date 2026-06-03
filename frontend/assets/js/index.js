function logar() {
    let usuario = document.getElementById('usuario').value;
    let senha = document.getElementById('senha').value;

    if (usuario === 'tutor' && senha === '123456') {
        window.location.href = 'frontend/pages/tutor/dashtutor.html';
    } else if (usuario === 'candidato' && senha === 'cand!098') {
        window.location.href = 'frontend/pages/tutor/dashtutor.html';
    } else if (usuario === 'Ong' && senha === 'ong$-135') {
        window.location.href = 'frontend/pages/ong/dashboardOng.html';
    } else if (usuario === 'prefeitura' && senha === 'pref@456') {
        window.location.href = 'frontend/pages/ong/dashboardOng.html';
    } else {
        alert('Usuário ou senha incorretos. Tente novamente.');
    }
}
