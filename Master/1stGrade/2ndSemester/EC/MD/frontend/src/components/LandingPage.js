import React from 'react';
import logo from "../imgs/politaiLogo.png"
import './LandingPage.css'
import {useNavigate} from 'react-router-dom';


function LandingPage(){
    const navigate = useNavigate();
    const handleSubmit= () =>{
        console.log("Redirecting");
        navigate("/login")
    };
    return(
        <div className="mainDiv">
            <div className="leftMember">
                <h1 className = "Logo">PolitAI</h1>
                <p className='paragraph'>Informar-se sobre os planos
                    eleitorais dos partidos 
                    portugueses nunca foi tão fácil...
                </p>
                <button className="launchapp" onClick={handleSubmit}>Experimente Já</button>
            </div>
            <div className='rightMember'>
                <img src={logo} alt='PolitAI logo' className="logo" />
            </div>

        </div>
    )
}

export default LandingPage;