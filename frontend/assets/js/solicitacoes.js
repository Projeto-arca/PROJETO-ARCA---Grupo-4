document.addEventListener('DOMContentLoaded', () => {
    
    const filterButtons = document.querySelectorAll('.filter-btn');
    
    filterButtons.forEach(button => {
        button.addEventListener('click', () => {
            filterButtons.forEach(btn => btn.classList.remove('active'));
            button.classList.add('active');
        });
    });

    const recentLocationItems = document.querySelectorAll('.recent-item');
    const localizacaoInput = document.getElementById('localizacao');

    recentLocationItems.forEach(item => {
        item.addEventListener('click', () => {
            const address = item.getAttribute('data-address');
            localizacaoInput.value = address;
            localizacaoInput.style.borderColor = '#1f4f40';
            setTimeout(() => {
                localizacaoInput.style.borderColor = '';
            }, 500);
        });
    });

    const form = document.getElementById('novaSolicitacaoForm');
    form.addEventListener('submit', (e) => {
        e.preventDefault();
        alert('Nova solicitação criada com sucesso!');
        form.reset();
    });
});