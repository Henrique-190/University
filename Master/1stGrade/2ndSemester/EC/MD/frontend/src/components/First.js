import {useEffect} from 'react';

function First() {
    useEffect(() => {
        const username = localStorage.getItem('username');
        
        if (!username) {
            window.location.href = '/Login';
        } else {
            fetch('http://localhost:8000/latestChat/' + username)
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        window.location.href = '/chat/' + data.redirect;
                    }
                });
        }
    }, []);    
}

export default First;