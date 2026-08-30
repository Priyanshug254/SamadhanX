import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../../context/AuthContext';
import { ShieldCheck, Lock, Mail, ArrowRight, CheckCircle2 } from 'lucide-react';

export const LoginPage: React.FC = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const { login } = useAuth();
  const navigate = useNavigate();

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    setLoading(true);
    try {
      await login(email, password);
      navigate('/government');
    } catch (err: any) {
      setError(err.response?.data?.message || 'Authentication failed. Please verify credentials.');
    } finally {
      setLoading(false);
    }
  };

  const setDemoUser = (demoEmail: string, demoPass: string) => {
    setEmail(demoEmail);
    setPassword(demoPass);
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-950 via-slate-900 to-slate-950 flex items-center justify-center p-4">
      <div className="w-full max-w-md">
        {/* Brand Header */}
        <div className="text-center mb-8">
          <div className="inline-flex w-14 h-14 rounded-2xl bg-gradient-to-tr from-amber-500 to-amber-600 items-center justify-center shadow-xl shadow-amber-500/20 mb-4 border border-amber-400/30">
            <span className="text-slate-950 font-black text-2xl tracking-tighter">SX</span>
          </div>
          <h1 className="text-2xl font-black text-white tracking-tight">
            Samadhan<span className="text-amber-500">X</span> Command Portal
          </h1>
          <p className="text-xs text-slate-400 mt-1.5 max-w-xs mx-auto">
            National Societal Problem-Solving, Multi-Institutional R&D & CSR Deployment Ecosystem
          </p>
        </div>

        {/* Login Card */}
        <div className="glass-panel-dark rounded-3xl p-8 shadow-2xl border border-slate-800">
          <div className="flex items-center gap-2 mb-6 text-xs font-bold uppercase tracking-wider text-amber-400">
            <ShieldCheck className="w-4 h-4" />
            <span>Secure Official Access</span>
          </div>

          {error && (
            <div className="mb-5 p-3.5 rounded-xl bg-rose-500/10 border border-rose-500/30 text-rose-300 text-xs font-medium">
              {error}
            </div>
          )}

          <form onSubmit={handleLogin} className="space-y-4">
            <div>
              <label className="block text-xs font-bold text-slate-300 mb-1.5">Official Email</label>
              <div className="relative">
                <Mail className="w-4 h-4 text-slate-400 absolute left-3.5 top-3" />
                <input
                  type="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  required
                  placeholder="name@gov.in or org.ac.in"
                  className="w-full pl-10 pr-4 py-2.5 rounded-xl bg-slate-900/90 border border-slate-700 text-white placeholder-slate-500 text-sm focus:outline-none focus:border-amber-500 focus:ring-1 focus:ring-amber-500"
                />
              </div>
            </div>

            <div>
              <label className="block text-xs font-bold text-slate-300 mb-1.5">Password</label>
              <div className="relative">
                <Lock className="w-4 h-4 text-slate-400 absolute left-3.5 top-3" />
                <input
                  type="password"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  required
                  placeholder="••••••••••••"
                  className="w-full pl-10 pr-4 py-2.5 rounded-xl bg-slate-900/90 border border-slate-700 text-white placeholder-slate-500 text-sm focus:outline-none focus:border-amber-500 focus:ring-1 focus:ring-amber-500"
                />
              </div>
            </div>

            <button
              type="submit"
              disabled={loading}
              className="w-full py-3 px-4 rounded-xl bg-gradient-to-r from-amber-500 to-amber-600 text-slate-950 font-bold text-sm shadow-lg shadow-amber-500/25 hover:from-amber-400 hover:to-amber-500 transition-all flex items-center justify-center gap-2 mt-2"
            >
              {loading ? (
                <span>Authenticating...</span>
              ) : (
                <>
                  <span>Sign In to Command Center</span>
                  <ArrowRight className="w-4 h-4" />
                </>
              )}
            </button>
          </form>

          {/* Quick Demo Persona Shortcuts */}
          <div className="mt-8 pt-6 border-t border-slate-800">
            <p className="text-[11px] font-bold uppercase tracking-wider text-slate-400 mb-3 text-center">
              1-Click Demo Accounts
            </p>
            <div className="grid grid-cols-2 gap-2">
              <button
                type="button"
                onClick={() => setDemoUser('admin@samadhanx.gov.in', 'Admin@123456')}
                className="p-2 rounded-lg bg-slate-800/80 hover:bg-slate-800 text-left border border-slate-700/60 text-xs transition-colors"
              >
                <p className="font-bold text-amber-400">Govt Admin</p>
                <p className="text-[10px] text-slate-400 truncate">admin@samadhanx.gov.in</p>
              </button>

              <button
                type="button"
                onClick={() => setDemoUser('official@samadhanx.gov.in', 'Official@123456')}
                className="p-2 rounded-lg bg-slate-800/80 hover:bg-slate-800 text-left border border-slate-700/60 text-xs transition-colors"
              >
                <p className="font-bold text-cyan-400">Dept Official</p>
                <p className="text-[10px] text-slate-400 truncate">official@samadhanx.gov.in</p>
              </button>

              <button
                type="button"
                onClick={() => setDemoUser('faculty@samadhanx.gov.in', 'Faculty@123456')}
                className="p-2 rounded-lg bg-slate-800/80 hover:bg-slate-800 text-left border border-slate-700/60 text-xs transition-colors"
              >
                <p className="font-bold text-purple-400">University Lead</p>
                <p className="text-[10px] text-slate-400 truncate">faculty@samadhanx.gov.in</p>
              </button>

              <button
                type="button"
                onClick={() => setDemoUser('industry@samadhanx.gov.in', 'Industry@123456')}
                className="p-2 rounded-lg bg-slate-800/80 hover:bg-slate-800 text-left border border-slate-700/60 text-xs transition-colors"
              >
                <p className="font-bold text-emerald-400">Industry / CSR</p>
                <p className="text-[10px] text-slate-400 truncate">industry@samadhanx.gov.in</p>
              </button>
            </div>
          </div>
        </div>

        <div className="text-center mt-6 text-[11px] text-slate-500">
          SamadhanX National GovTech Infrastructure • SIH Problem Statement 26043
        </div>
      </div>
    </div>
  );
};
