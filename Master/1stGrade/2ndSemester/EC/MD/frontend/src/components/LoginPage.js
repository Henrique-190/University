import React, { useState } from 'react';
import './LoginPage.css';
import { useNavigate } from 'react-router-dom';

function Login() {
    const [username, setUsername] = useState('');
    const [password, setPassword] = useState('');
    const navigate = useNavigate();

    const handleLogin = (event) => {
        if (username === '' || password === '') {
            alert('Please enter username and password');
            return;
        }
        event.preventDefault();
        fetch('http://localhost:8000/login', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ "id": username, "password": password }),
        })
            .then(response => response.json())
            .then(data => {
                if (data) { 
                    localStorage.setItem('username', username);
                    navigate(data.redirect)
                }
                else{
                    alert("Invalid username or password");
                    setPassword('');
                    setUsername('');
                }
            });
    }

    const handleRegister = (event) => {
        if (username === '' || password === '') {
            alert('Please enter username and password');
            return;
        }
        event.preventDefault();
        fetch('http://localhost:8000/login', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ "id": username, "password": password }),
        })
            .then(response => response.json())
            .then(data => {
                if (data) { 
                    localStorage.setItem('username', username);
                    navigate("/chat")
                }
                else{
                    alert("Invalid username or password");
                    setPassword('');
                    setUsername('');
                }
            });
    }


    const handleKeyDown = (event) => {
        if(event.key === 'Enter'){
          handleLogin();
        }
      }

    return (
        <div className="mainDiv">
            <button className="logo">PolitAI</button>
            <div className="wrapper">
                <div className='inputWrapper'>
                    <input className="username" type="text" value={username} placeholder='Username...' onChange={e => setUsername(e.target.value)} onKeyDown={handleKeyDown}/>
                    <input className="password" type="password" value={password}  placeholder='Password...' onChange={e => setPassword(e.target.value)} onKeyDown={handleKeyDown} />
                
                </div>
                <div className='buttonWrapper'>
                    <button className="login" onClick={handleLogin}>Login</button>
                    <button className="register" onClick={handleRegister}>Register</button>
                </div>
                
            </div>
            <button className="guest" onClick={() => console.log("teste")}>Continuar como convidado</button>
        </div>
    );
}

export default Login;
