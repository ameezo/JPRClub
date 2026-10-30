import { useEffect, useState } from 'react';
import { apiClient } from '@/lib/api';
import { User as UserIcon, CheckCircle } from 'lucide-react';
import Button from '@/components/ui/Button';

interface User {
  id: string;
  name: string;
  email: string;
  role: string;
}

export default function AdminUsers() {
  const [users, setUsers] = useState<User[]>([]);
  const [loading, setLoading] = useState(true);

  const fetchUsers = async () => {
    try {
      const response = await apiClient.get('/users');
      setUsers(response.data);
    } catch (error) {
      console.error('Failed to fetch users:', error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchUsers();
  }, []);

  const handleVerify = async (id: string) => {
    try {
      await apiClient.post(`/users/${id}/verify`);
      fetchUsers();
    } catch (error) {
      console.error('Failed to verify user:', error);
      alert('Failed to verify user');
    }
  };

  return (
    <div>
      <div className="admin-dashboard-header">
        <div className="admin-dashboard-title-group">
          <h1>Member Verification</h1>
          <p>Verify new members to allow them to submit journal entries</p>
        </div>
      </div>

      <div className="admin-list-card">
        {loading ? (
          <div className="p-8 text-center text-gray-500">Loading...</div>
        ) : users.length === 0 ? (
          <div className="p-8 text-center text-gray-500">No users found.</div>
        ) : (
          <div>
            {users.map((user) => (
              <div key={user.id} className="admin-session-row">
                <div className="admin-session-main">
                  <div className="admin-session-status-icon">
                    <UserIcon style={{ width: '18px', height: '18px', color: '#9ca3af' }} />
                  </div>
                  <div className="admin-session-content">
                    <div className="admin-session-title-line">
                      <h3 className="admin-session-title">{user.name}</h3>
                      <span className={`admin-status-badge ${user.role === 'verified' ? 'admin-status-published' : 'admin-status-draft'}`}>
                        {user.role}
                      </span>
                    </div>
                    <div className="admin-session-meta">
                      <span>{user.email}</span>
                    </div>
                  </div>
                </div>
                
                <div className="admin-row-actions">
                  {user.role === 'member' && (
                    <Button onClick={() => handleVerify(user.id)} variant="primary" className="text-xs py-1">
                      <CheckCircle style={{ width: '14px', height: '14px', marginRight: '4px' }} />
                      Verify Member
                    </Button>
                  )}
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
