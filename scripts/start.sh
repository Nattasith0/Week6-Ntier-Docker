#!/bin/bash
echo "🐳 Starting Task Board (Docker Version)..."
docker compose up -d
echo ""
echo "⏳ Waiting for services to be ready..."
sleep 5
echo ""
echo "📊 Service Status:"
docker compose ps
echo ""
echo "✅ Task Board is running!"
echo "🌐 Open https://localhost in your browser"
echo ""
echo "📝 Useful commands:"
echo "   docker compose logs -f     # View logs"
echo "   docker compose ps          # Check status"
echo "   docker compose down        # Stop all"
EOF

# Stop script
cat > scripts/stop.sh << 'EOF'
#!/bin/bash
echo "🛑 Stopping Task Board..."
docker compose down
echo "✅ All services stopped"
EOF

# Logs script
cat > scripts/logs.sh << 'EOF'
#!/bin/bash
echo "📋 Viewing logs (Ctrl+C to exit)..."
docker compose logs -f