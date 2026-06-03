function alternarMenu() {
    var menu = document.getElementById('menu-dropdown');
    menu.classList.toggle('aberto');
}

document.addEventListener('click', function(evento) {
    var menuUsuario = document.querySelector('.menu-usuario');
    if (!menuUsuario.contains(evento.target)) {
        document.getElementById('menu-dropdown').classList.remove('aberto');
    }
});

function filtrar(botaoClicado) {
    let botoes = document.querySelectorAll('.botao-filtro');
    for (let i = 0; i < botoes.length; i++) {
        botoes[i].classList.remove('ativo');
    }
    botaoClicado.classList.add('ativo');

    let filtro = botaoClicado.textContent;
    let linhas = document.querySelectorAll('.tabela-solicitacoes tbody tr');

    for (let i = 0; i < linhas.length; i++) {
        let tipoServico = linhas[i].cells[2].textContent;
        if (filtro === 'Todos' || tipoServico === filtro) {
            linhas[i].style.display = '';
        } else {
            linhas[i].style.display = 'none';
        }
    }
}
