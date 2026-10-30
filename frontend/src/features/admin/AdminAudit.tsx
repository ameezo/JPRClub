import { useEffect, useState } from 'react';
import { apiClient } from '@/lib/api';
import { Activity, Server } from 'lucide-react';

interface AuditLog {
  id: number;
  timestamp: string;
  method: string;
  path: string;
  ip_address: string;
  user_agent: string;
  status_code: number;
  process_time: number;
  user_id: string | null;
}

export default function AdminAudit() {
  const [logs, setLogs] = useState<AuditLog[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchLogs = async () => {
      try {
        const response = await apiClient.get('/audit?limit=100');
        setLogs(response.data);
      } catch (error) {
        console.error('Failed to fetch audit logs', error);
      } finally {
        setLoading(false);
      }
    };
    fetchLogs();
  }, []);

  return (
    <div>
      <div className="flex justify-between items-center mb-8">
        <div>
          <h1 className="text-3xl font-bold font-display text-gray-900 mb-2">Audit Logs</h1>
          <p className="text-gray-500">View real-time API requests, methods, and processing times.</p>
        </div>
        <div className="bg-primary/10 text-primary p-4 rounded-2xl flex items-center">
          <Activity className="w-8 h-8" />
        </div>
      </div>

      <div className="bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden">
        {loading ? (
          <div className="p-12 text-center text-gray-500">Loading logs...</div>
        ) : logs.length === 0 ? (
          <div className="p-12 text-center text-gray-500">
            <Server className="w-12 h-12 mx-auto mb-4 text-gray-300" />
            <p>No audit logs available yet.</p>
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full text-left">
              <thead>
                <tr className="bg-gray-50/50 border-b border-gray-100">
                  <th className="p-4 font-semibold text-gray-600">Time</th>
                  <th className="p-4 font-semibold text-gray-600">Method</th>
                  <th className="p-4 font-semibold text-gray-600">Path</th>
                  <th className="p-4 font-semibold text-gray-600">Status</th>
                  <th className="p-4 font-semibold text-gray-600">Time (s)</th>
                  <th className="p-4 font-semibold text-gray-600">IP</th>
                  <th className="p-4 font-semibold text-gray-600">User ID</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-100">
                {logs.map((log) => (
                  <tr key={log.id} className="hover:bg-gray-50/50">
                    <td className="p-4 text-sm text-gray-500">
                      {new Date(log.timestamp).toLocaleString()}
                    </td>
                    <td className="p-4">
                      <span className={`inline-flex px-2 py-1 text-xs font-bold rounded-lg ${
                        log.method === 'GET' ? 'bg-blue-100 text-blue-700' :
                        log.method === 'POST' ? 'bg-green-100 text-green-700' :
                        log.method === 'PATCH' || log.method === 'PUT' ? 'bg-yellow-100 text-yellow-700' :
                        log.method === 'DELETE' ? 'bg-red-100 text-red-700' :
                        'bg-gray-100 text-gray-700'
                      }`}>
                        {log.method}
                      </span>
                    </td>
                    <td className="p-4 text-sm font-mono text-gray-600">
                      {log.path}
                    </td>
                    <td className="p-4 text-sm font-mono text-gray-600">
                      <span className={log.status_code >= 400 ? 'text-red-600' : 'text-green-600'}>
                        {log.status_code}
                      </span>
                    </td>
                    <td className="p-4 text-sm font-mono text-gray-500">
                      {log.process_time ? log.process_time.toFixed(4) : '-'}
                    </td>
                    <td className="p-4 text-sm text-gray-500 font-mono">
                      {log.ip_address}
                    </td>
                    <td className="p-4 text-sm text-gray-500 font-mono">
                      {log.user_id ? log.user_id.substring(0,8) + '...' : 'Anonymous'}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  );
}
