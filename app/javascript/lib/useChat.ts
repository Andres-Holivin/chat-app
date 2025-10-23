import { useEffect, useState, useCallback } from 'react';
import cable from '../lib/cable';

interface Message {
    id: number;
    content: string;
    username: string;
    created_at?: string;
}

interface UseChatReturn {
    messages: Message[];
    sendMessage: (content: string, username: string) => Promise<void>;
    isConnected: boolean;
}

export const useChat = (): UseChatReturn => {
    const [messages, setMessages] = useState<Message[]>([]);
    const [isConnected, setIsConnected] = useState(false);

    useEffect(() => {
        fetch('/messages')
            .then(response => response.json())
            .then(data => {
                setMessages(data);
            })
            .catch(error => console.error('Error fetching messages:', error));

        const subscription = cable.subscriptions.create('ChatChannel', {
            connected() {
                console.log('Connected to ChatChannel');
                setIsConnected(true);
            },
            disconnected() {
                console.log('Disconnected from ChatChannel');
                setIsConnected(false);
            },
            received(data: Message) {
                console.log('Received message:', data);
                setMessages(prevMessages => {
                    if (prevMessages.some(msg => msg.id === data.id)) {
                        return prevMessages;
                    }
                    return [...prevMessages, data];
                });
            }
        });
        return () => {
            subscription.unsubscribe();
        };
    }, []);

    const sendMessage = useCallback(async (content: string, username: string) => {
        try {
            const response = await fetch('/messages', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    message: {
                        content,
                        username
                    }
                })
            });

            if (!response.ok) {
                throw new Error('Failed to send message');
            }
        } catch (error) {
            console.error('Error sending message:', error);
            throw error;
        }
    }, []);

    return { messages, sendMessage, isConnected };
};
