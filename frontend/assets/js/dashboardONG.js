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
