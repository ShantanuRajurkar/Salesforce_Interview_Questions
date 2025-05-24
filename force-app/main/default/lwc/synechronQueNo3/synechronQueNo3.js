import { LightningElement } from 'lwc';

export default class SynechronQueNo3 extends LightningElement {
    gameWidth = 600;
    gameHeight = 400;
    paddleWidth = 100;
    paddleHeight = 20;
    ballSize = 20;

    paddleX = 250;
    ballX = 290;
    ballY = 200;
    ballSpeedY = 2;
    ballSpeedX = 2;
    score = 0;
    gameOver = false;
    animationFrameId;

    connectedCallback() {
        this.startGame();
        window.addEventListener('keydown', this.handleKeyDown.bind(this));
    }

    disconnectedCallback() {
        cancelAnimationFrame(this.animationFrameId);
        window.removeEventListener('keydown', this.handleKeyDown.bind(this));
    }

    get paddleStyle() {
        return `width: ${this.paddleWidth}px; height: ${this.paddleHeight}px; left: ${this.paddleX}px; bottom: 0px;`;
    }

    get ballStyle() {
        return `width: ${this.ballSize}px; height: ${this.ballSize}px; left: ${this.ballX}px; top: ${this.ballY}px;`;
    }

    handleKeyDown(event) {
        if (this.gameOver && event.key === 'Enter') {
            this.resetGame();
            return;
        }

        const moveAmount = 20;
        if (event.key === 'ArrowLeft') {
            this.paddleX = Math.max(0, this.paddleX - moveAmount);
        } else if (event.key === 'ArrowRight') {
            this.paddleX = Math.min(this.gameWidth - this.paddleWidth, this.paddleX + moveAmount);
        }
    }

    startGame() {
        const update = () => {
            if (this.gameOver) return;

            this.ballX += this.ballSpeedX;
            this.ballY += this.ballSpeedY;

            // Wall collision
            if (this.ballX <= 0 || this.ballX + this.ballSize >= this.gameWidth) {
                this.ballSpeedX *= -1;
            }

            // Paddle collision
            if (
                this.ballY + this.ballSize >= this.gameHeight - this.paddleHeight &&
                this.ballX + this.ballSize >= this.paddleX &&
                this.ballX <= this.paddleX + this.paddleWidth &&
                this.ballSpeedY > 0
            ) {
                this.ballSpeedY *= -1;
                this.ballY = this.gameHeight - this.paddleHeight - this.ballSize; // prevent sticking
                this.score += 1;
            }

            // Top collision
            if (this.ballY <= 0) {
                this.ballSpeedY *= -1;
                this.ballY = 0;
            }

            // Bottom collision
            if (this.ballY >= this.gameHeight) {
                this.gameOver = true;
                cancelAnimationFrame(this.animationFrameId);
                return;
            }

            this.animationFrameId = requestAnimationFrame(update);
        };

        this.animationFrameId = requestAnimationFrame(update);
    }

    resetGame() {
        this.paddleX = 250;
        this.ballX = 290;
        this.ballY = 200;
        this.ballSpeedY = 2;
        this.ballSpeedX = 2;
        this.score = 0;
        this.gameOver = false;
        this.startGame();
    }
}