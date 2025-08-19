import pygame
import random

# Initialize Pygame
pygame.init()

# Screen dimensions
WIDTH, HEIGHT = 400, 600
screen = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("Subway Surfer Clone")

# Colors
WHITE = (255, 255, 255)
GRAY = (50, 50, 50)
BLUE = (0, 100, 255)
RED = (255, 50, 50)

# Game variables
PLAYER_SIZE = 40
PLAYER_Y = HEIGHT - PLAYER_SIZE - 30
LANES = [WIDTH // 4, WIDTH // 2, 3 * WIDTH // 4]
player_lane = 1

OBSTACLE_WIDTH = 40
OBSTACLE_HEIGHT = 40
obstacle_speed = 7
obstacles = []

score = 0
font = pygame.font.SysFont('Arial', 24)

clock = pygame.time.Clock()
running = True

def spawn_obstacle():
    lane = random.choice([0, 1, 2])
    x = LANES[lane] - OBSTACLE_WIDTH // 2
    y = -OBSTACLE_HEIGHT
    obstacles.append(pygame.Rect(x, y, OBSTACLE_WIDTH, OBSTACLE_HEIGHT))

def draw():
    screen.fill(GRAY)
    # Draw lanes
    for x in LANES:
        pygame.draw.line(screen, WHITE, (x, 0), (x, HEIGHT), 2)
    # Draw player
    player_rect = pygame.Rect(LANES[player_lane] - PLAYER_SIZE // 2, PLAYER_Y, PLAYER_SIZE, PLAYER_SIZE)
    pygame.draw.rect(screen, BLUE, player_rect)
    # Draw obstacles
    for obs in obstacles:
        pygame.draw.rect(screen, RED, obs)
    # Draw score
    score_surf = font.render(f"Score: {score}", True, WHITE)
    screen.blit(score_surf, (10, 10))
    pygame.display.flip()

while running:
    clock.tick(60)
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False
        elif event.type == pygame.KEYDOWN:
            if event.key == pygame.K_LEFT and player_lane > 0:
                player_lane -= 1
            elif event.key == pygame.K_RIGHT and player_lane < 2:
                player_lane += 1

    # Spawn obstacles
    if random.randint(0, 30) == 0:
        spawn_obstacle()

    # Move obstacles
    for obs in obstacles[:]:
        obs.y += obstacle_speed
        if obs.y > HEIGHT:
            obstacles.remove(obs)
            score += 1

    # Collision check
    player_rect = pygame.Rect(LANES[player_lane] - PLAYER_SIZE // 2, PLAYER_Y, PLAYER_SIZE, PLAYER_SIZE)
    for obs in obstacles:
        if player_rect.colliderect(obs):
            running = False

    draw()

pygame.quit()
print("Game Over! Final Score:", score)
