import React, { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import './Chat.css';
import './iMessage.css';

function Chat() {
  const {chat_id } = useParams();
  const [user_id] = useState(localStorage.getItem('username'));
  const [data, setData] = useState([]);
  const [chats, setChats] = useState([]);
  const [inputValue, setInputValue] = useState("");
  
  const navigate = useNavigate();
  useEffect(() => {
    if (!user_id) {
      window.location.href = '/login';
    }
    fetch(`http://localhost:8000/chat/${user_id}/${chat_id}`)
      .then(response => response.json())
      .then(data => setData(data[0].data));
    
    fetch(`http://localhost:8000/chats/${user_id}`)
      .then(response => response.json())
      .then(data => setChats(data.data));
  }, [user_id, chat_id]);

  const handleSend = () => {
    if (!user_id) {
      window.location.href = '/login';
      return;
    }
    const new_question = { question: inputValue, type: 'sent' };
    const wait = { question: '...', type: 'received'}
    setData([...data, new_question, wait]);
    setInputValue('');
    fetch('http://localhost:8000/query', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ query: inputValue }),
    })
    .then(response => response.json())
    .then(answer => {
      setData([...data, new_question, answer]);
      setInputValue('');
    }
    );
  
  };

  const handleKeyDown = (event) => {
    if(event.key === 'Enter'){
      handleSend();
    }
  }

  return (
  <div className="Chat_page">
    <div className='Chats_1'>Chats</div>
    <div className='Logout' onClick={() => {
        localStorage.removeItem('username');
        window.location.reload();
      }}><p className='Logout_text'>Logout</p></div>
    <div className='Rectangle_1'></div>
    <div className='Rectangle_6'></div>
    <div className='Rectangle_7'></div>
    <input type="text"  className="Rectangle_8" value={inputValue} onChange={e => setInputValue(e.target.value)} onKeyDown={handleKeyDown} />
    <div className='Rectangle_11'>
      {chats.map((chat) => (
            <div className='Chats_list' key={chat} onClick={() => {
              navigate(`/chat/${chat}`)}}>
                {chat.substring(0,7)}
            </div>
      ))}
    </div>
    <div className='Rectangle_12'>
      {data.map((message, index) => (
        <p key={index} className={message.type === 'sent' ? 'from-me' : 'from-them'}>
          {message.question}{message.answer}
          <br />
          {message.source && <span> Source: {message.source}</span>}
        </p>
      ))}
    </div>
    <div className='Polygon_1' onClick={handleSend}></div>
  </div>
  );
}

export default Chat;
