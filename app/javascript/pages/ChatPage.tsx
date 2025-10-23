import * as React from 'react';
import { useNavigate } from 'react-router-dom';
import { Button } from '../components/ui/button';
import { useChat } from '../lib/useChat';
import { Input } from '@/components/ui/input';
import { MessageCircleMore } from 'lucide-react';

const ChatPage: React.FC = () => {
    const navigate = useNavigate();
    const [username, setUsername] = React.useState('');
    const { messages, sendMessage, isConnected } = useChat();
    const [inputMessage, setInputMessage] = React.useState('');
    const [isSending, setIsSending] = React.useState(false);
    const messagesEndRef = React.useRef<HTMLDivElement>(null);

    React.useEffect(() => {
        const savedUsername = localStorage.getItem('chatUsername');
        if (!savedUsername) {
            navigate('/');
            return;
        }
        setUsername(savedUsername);
    }, [navigate]);

    React.useEffect(() => {
        messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
    }, [messages]);

    const handleSendMessage = async () => {
        if (inputMessage.trim() && username.trim() && !isSending) {
            setIsSending(true);
            try {
                await sendMessage(inputMessage, username);
                setInputMessage('');
            } catch (error) {
                console.error('Failed to send message:', error);
                alert('Failed to send message. Please try again.');
            } finally {
                setIsSending(false);
            }
        }
    };

    const handleKeyPress = (e: React.KeyboardEvent<HTMLInputElement>) => {
        if (e.key === 'Enter') {
            e.preventDefault();
            handleSendMessage();
        }
    };

    const handleLogout = () => {
        localStorage.removeItem('chatUsername');
        navigate('/');
    };

    const getMessageClassName = (sender: string) => {
        if (sender === username) {
            return 'bg-linear-to-br from-blue-500 to-blue-600 text-white';
        }
        if (sender === 'System') {
            return 'bg-linear-to-br from-purple-500 to-purple-600 text-white';
        }
        return 'bg-white dark:bg-slate-800 text-slate-900 dark:text-white border border-slate-200 dark:border-slate-700';
    };

    const formatTime = (timestamp?: string) => {
        if (!timestamp) return '';
        const date = new Date(timestamp);
        return date.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit' });
    };
    if (!username) {
        return null;
    }

    return (
        <div className="h-screen flex flex-col bg-linear-to-br from-slate-50 to-slate-100">
            <header className=" shadow-sm border-b border-slate-200 dark:border-slate-700">
                <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
                    <div className="flex items-center justify-between">
                        <div className="flex items-center gap-3">
                            <div className="w-10 h-10 bg-linear-to-br from-blue-500 to-purple-600 rounded-lg flex items-center justify-center">
                                <MessageCircleMore className='text-white' />
                            </div>
                            <div>
                                <h1 className="text-2xl font-bold ">Chat App</h1>
                                <p className="text-sm text-slate-500 dark:text-slate-400">Logged in as {username}</p>
                            </div>
                        </div>
                        <div className="flex items-center gap-3">
                            <span className={`inline-flex items-center gap-1.5 px-3 py-1.5 rounded-full text-xs font-medium ${isConnected
                                ? 'bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-200'
                                : 'bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-200'
                                }`}>
                                <span className={`w-2 h-2 ${isConnected ? 'bg-green-500' : 'bg-red-500'} rounded-full ${isConnected ? 'animate-pulse' : ''}`} />
                                {isConnected ? 'Connected' : 'Disconnected'}
                            </span>
                            <Button
                                onClick={handleLogout}
                                variant="outline"
                            >
                                Logout
                            </Button>
                        </div>
                    </div>
                </div>
            </header>
            <main className="flex-1 w-full px-8 flex justify-center items-center">
                <div className="w-full rounded-2xl shadow-xl border border-slate-200 dark:border-slate-700 overflow-hidden">
                    <div className="h-[75vh] overflow-y-auto p-6 space-y-4 bg-slate-50 dark:bg-slate-900/50">
                        {messages.length === 0 ? (
                            <div className="flex items-center justify-center h-full">
                                <div className="text-center">
                                    <div className="w-16 h-16 bg-slate-200 dark:bg-slate-700 rounded-full flex items-center justify-center mx-auto mb-4">
                                        <MessageCircleMore className='text-gray-400' />
                                    </div>
                                    <p className="text-slate-500 dark:text-slate-400">No messages yet. Start the conversation!</p>
                                </div>
                            </div>
                        ) : (
                            <>
                                {messages.map((message) => (
                                    <div
                                        key={message.id}
                                        className={`flex ${message.username === username ? 'justify-end' : 'justify-start'}`}
                                    >
                                        <div className={`max-w-xs lg:max-w-md px-4 py-3 rounded-2xl shadow-sm ${getMessageClassName(message.username)}`}>
                                            <div className="flex items-center justify-between mb-1">
                                                <p className="text-xs font-semibold opacity-90">{message.username}</p>
                                                {message.created_at && (
                                                    <p className="text-xs opacity-75 ml-2">{formatTime(message.created_at)}</p>
                                                )}
                                            </div>
                                            <p className="text-sm wrap-break-word">{message.content}</p>
                                        </div>
                                    </div>
                                ))}
                                <div ref={messagesEndRef} />
                            </>
                        )}
                    </div>
                    <div className="p-4 border-t border-slate-200 dark:border-slate-700">
                        <div className="flex gap-3">
                            <Input
                                type="text"
                                value={inputMessage}
                                onChange={(e) => setInputMessage(e.target.value)}
                                onKeyDown={handleKeyPress}
                                placeholder="Type your message..."
                                disabled={!isConnected || isSending}
                            />
                            <Button
                                onClick={handleSendMessage}
                                disabled={!inputMessage.trim() || !isConnected || isSending}
                            >
                                {isSending ? 'Sending...' : 'Send'}
                            </Button>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    );
};

export default ChatPage;
