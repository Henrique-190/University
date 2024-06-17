// src/App.js
import React from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import Chat from './components/Chat';
import LandingPage from './components/LandingPage';
import Login from './components/LoginPage';
// import Login from './components/Login';
// import Register from './components/Register';
// import First from './components/First';


function App() {
  return (
    <Router>
      <Routes>
        <Route path="/login" element={<Login />} />
        <Route path="/chat/:chat_id" element={<Chat />} />
        <Route path="/" element={<LandingPage />} />
      </Routes>
    </Router>
  );
}

export default App;
