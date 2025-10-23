import * as React from 'react';
import { useNavigate } from 'react-router-dom';
import { Button } from '../components/ui/button';
import { Input } from '@/components/ui/input';
import { MessageCircleMore } from 'lucide-react';

const SetUsername: React.FC = () => {
    const [username, setUsername] = React.useState('');
    const navigate = useNavigate();

    React.useEffect(() => {
        const savedUsername = localStorage.getItem('chatUsername');
        if (savedUsername) {
            navigate('/chat');
        }
    }, [navigate]);

    const handleSetUsername = () => {
        if (username.trim()) {
            localStorage.setItem('chatUsername', username.trim());
            navigate('/chat');
        }
    };

    const handleKeyPress = (e: React.KeyboardEvent<HTMLInputElement>) => {
        if (e.key === 'Enter') {
            e.preventDefault();
            handleSetUsername();
        }
    };

    return (
        <div className="min-h-screen bg-linear-to-br from-slate-50 to-slate-100 flex items-center justify-center p-4">
            <div className="rounded-2xl shadow-xl border border-slate-200 p-8 max-w-md w-full">
                <div className="text-center mb-6">
                    <div className="w-16 h-16 bg-linear-to-br from-blue-500 to-purple-600 rounded-2xl flex items-center justify-center mx-auto mb-4 transform hover:scale-105 transition-transform">
                        <svg className="w-10 h-10 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <MessageCircleMore />
                        </svg>
                    </div>
                    <h1 className="text-3xl font-bold text-slate-900  mb-2">Welcome to Chat App</h1>
                    <p className="text-slate-600">Enter your name to start chatting</p>
                </div>
                <div className="space-y-4">
                    <div>
                        <label htmlFor="username" className="block text-sm font-medium text-slate-700 mb-2">
                            Your Name
                        </label>
                        <Input
                            id="username"
                            type="text"
                            value={username}
                            onChange={(e) => setUsername(e.target.value)}
                            onKeyDown={handleKeyPress}
                            placeholder="Enter your name..."
                        />
                    </div>
                    <Button
                        onClick={handleSetUsername}
                        disabled={!username.trim()}
                        className='w-full'
                    >
                        Join Chat
                    </Button>
                </div>
                <div className="mt-6 pt-6 border-t border-slate-200">
                    <p className="text-xs text-center text-slate-500">
                        By joining, you agree to be awesome and respectful to others
                    </p>
                </div>
            </div>
        </div>
    );
};

export default SetUsername;
