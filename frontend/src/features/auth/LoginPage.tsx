import { useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import axios from 'axios';
import { apiClient } from '@/lib/api';

export default function LoginPage() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setLoading(true);
    
    try {
      const response = await apiClient.post('/auth/login', { email, password });
      const { access_token, user } = response.data;
      
      localStorage.setItem('token', access_token);
      localStorage.setItem('user', JSON.stringify(user));
      window.dispatchEvent(new Event('storage'));
      
      if (user.role === 'admin' || user.role === 'organizer') {
        navigate('/admin');
      } else {
        navigate('/');
      }
    } catch (err: any) {
      if (axios.isAxiosError(err) && err.response) {
        setError(err.response.data.detail || 'Invalid email or password');
      } else {
        setError('An unexpected error occurred. Please try again.');
      }
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="public-page-wrapper bg-gray">
      <div className="auth-page-wrapper">
        <div className="auth-card">
          <div className="auth-card-accent-bar" />
          
          <div className="auth-card-header">
            <div className="auth-brand-badge">
              <img src="/logo.jpeg" alt="JPR Club" />
            </div>
            <h1 className="auth-title">Sign In</h1>
            <p className="auth-subtitle">Access your JPR Club account</p>
          </div>

          {error && (
            <div className="auth-alert-error">
              {error}
            </div>
          )}

          <form className="auth-form" onSubmit={handleLogin}>
            <div className="auth-field">
              <label className="auth-label">Email Address</label>
              <input
                type="email"
                required
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="name@example.com"
                className="auth-input"
              />
            </div>

            <div className="auth-field">
              <label className="auth-label">Password</label>
              <input
                type="password"
                required
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder="••••••••"
                className="auth-input"
              />
            </div>

            <button
              type="submit"
              disabled={loading}
              className="auth-submit-btn"
            >
              {loading ? 'Signing in...' : 'Sign In'}
            </button>
          </form>
          
          <div className="auth-footer-text">
            <span>Don't have an account? </span>
            <Link to="/register" className="auth-link">
              Register here
            </Link>
          </div>
        </div>
      </div>
    </div>
  );
}
