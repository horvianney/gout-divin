import React from 'react'
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom'

// Import des pages HTML statiques
import './App.css'

function App() {
  return (
    <Router>
      <div className="App">
        <Routes>
          <Route path="/" element={<div>
            <h1>GOUT DIVIN - Restaurant Togo</h1>
            <nav>
              <ul>
                <li><a href="/gout-divin-login.html">Connexion</a></li>
                <li><a href="/gout-divin-pos.html">Point de Vente</a></li>
                <li><a href="/gout-divin-dashboard.html">Tableau de Bord</a></li>
                <li><a href="/gout-divin-clients.html">Clients</a></li>
                <li><a href="/gout-divin-menu.html">Menu</a></li>
                <li><a href="/gout-divin-stock.html">Stock</a></li>
              </ul>
            </nav>
          </div>} />
          <Route path="/login" element={<div>Redirection vers login...</div>} />
        </Routes>
      </div>
    </Router>
  )
}

export default App
