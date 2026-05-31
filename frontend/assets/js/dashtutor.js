document.addEventListener('DOMContentLoaded', () => {
    
    const cadastrarBtn = document.querySelector('.btn-light');
    if(cadastrarBtn) {
        cadastrarBtn.addEventListener('click', () => {
            console.log('Navegando para o formulário de cadastro de pets...');
        });
    }

    const acoesCards = document.querySelectorAll('.btn-dark');
    acoesCards.forEach(botao => {
        botao.addEventListener('click', (e) => {
            const acao = e.target.textContent.trim();
            console.log(`Ação solicitada: ${acao}`);
        });
    });

    const atalhos = document.querySelectorAll('.action-card, .location-banner');
    atalhos.forEach(atalho => {
        atalho.addEventListener('click', (e) => {
            e.preventDefault();
            console.log('Atalho clicado!');
            
            atalho.style.opacity = '0.7';
            setTimeout(() => {
                atalho.style.opacity = '1';
            }, 150);
        });
    });
});