import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adventure/components/collision_block.dart';
import 'package:pixel_adventure/components/player.dart';

class Level extends World {
  final String levelName;
  final Player player;
  Level({required this.levelName, required this.player});

  late TiledComponent level;
  List<CollisionBlock> collisionBlocks = [];

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));

    add(level);
    //add(player);

    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');
    if (spawnPointsLayer != null) {
      for (final spawnPoint in spawnPointsLayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            add(player);
            break;
          default:
        }
      }
    }

    final collisionLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');

    if (collisionLayer != null) {
      for (final collisionPoint in collisionLayer.objects) {
        switch (collisionPoint.class_) {
          case 'Platform':
            final platform = CollisionBlock(
              position: Vector2(collisionPoint.x, collisionPoint.y),
              size: Vector2(collisionPoint.width, collisionPoint.height),
              isPlatform: true,
            );
            collisionBlocks.add(platform);
            add(platform);
            break;
          default:
            final block = CollisionBlock(
              position: Vector2(collisionPoint.x, collisionPoint.y),
              size: Vector2(collisionPoint.width, collisionPoint.height),
              isPlatform: false,
            );
            collisionBlocks.add(block);
            add(block);
        }
      }
    }
    player.collisionBlocks = collisionBlocks;

    return super.onLoad();
  }
}
