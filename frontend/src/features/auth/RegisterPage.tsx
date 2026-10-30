import { useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { apiClient } from '@/lib/api';

export default function RegisterPage() {
  const [email, setEmail] = useState('');
  const [name, setName] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();

  const handleRegister = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    setLoading(true);
    
    try {
      const response = await apiClient.post('/auth/register', { email, name, password });
      let token = response.data?.access_token;
      let user = response.data?.user;

      if (!token) {
        const loginRes = await apiClient.post('/auth/login', { email, password });
        token = loginRes.data?.access_token;
        user = loginRes.data?.user;
      }

      if (token && user) {
        localStorage.setItem('token', token);
        localStorage.setItem('user', JSON.stringify(user));
        window.dispatchEvent(new Event('storage'));
      }

      // Return directly to the homepage with the registered user logged in
      navigate('/');
    } catch (err: any) {
      if (err.response && err.response.data) {
        setError(err.response.data.detail || 'Registration failed');
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
            <h1 className="auth-title">Join JPR Club</h1>
            <p className="auth-subtitle">Create an account to submit articles & join sessions</p>
          </div>

          {error && (
            <div className="auth-alert-error">
              {error}
            </div>
          )}

          <form className="auth-form" onSubmit={handleRegister}>
            <div className="auth-field">
              <label className="auth-label">Full Name</label>
              <input
                type="text"
                required
                value={name}
                onChange={(e) => setName(e.target.value)}
                placeholder="e.g. Taro Tanaka"
                className="auth-input"
              />
            </div>

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
              {loading ? 'Creating Account...' : 'Register'}
            </button>
          </form>
          
          <div className="auth-footer-text">
            <span>Already have an account? </span>
            <Link to="/login" className="auth-link">
              Log in
            </Link>
          </div>
        </div>
      </div>
    </div>
  );
}
