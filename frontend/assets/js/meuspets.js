document.addEventListener('DOMContentLoaded', () => {
    const searchInput = document.getElementById('petSearch');
    const petCards = document.querySelectorAll('.pet-card');

    searchInput.addEventListener('input', (e) => {
        const searchTerm = e.target.value.toLowerCase().trim();

        petCards.forEach(card => {
            const petName = card.querySelector('.pet-name h3').textContent.toLowerCase();
            
            if (petName.includes(searchTerm)) {
                card.style.display = 'flex'; 
            } else {
                card.style.display = 'none'; 
            }
        });
    });
});