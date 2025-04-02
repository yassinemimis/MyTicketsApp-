import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class FlipTramCard extends StatefulWidget {
  final String  code;
   final Map<String, dynamic> user;
  FlipTramCard({required this.user, required this.code});
  @override
  _FlipTramCardState createState() => _FlipTramCardState();
}

class _FlipTramCardState extends State<FlipTramCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
  }

  void _flipCard() {
    if (_isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    _isFront = !_isFront;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: _flipCard,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(_animation.value * 3.1416),
            alignment: Alignment.center,
            child: _isFront ? FrontCard(width: width, height: height,code:  widget.code,user:  widget.user, ) : BackCard(width: width, height: height),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class FrontCard extends StatelessWidget {
  final double width;
  final double height;
  final String code;
  final Map<String, dynamic> user;
  const FrontCard({required this.width, required this.height, required this.code, required this.user});

  @override
  Widget build(BuildContext context) {
    return CardBackground(
      cardWidth: width * 0.9,
      cardHeight: height * 0.3,
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tram card',
                style: TextStyle(
                  fontSize: width * 0.06,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
              SizedBox(height: height * 0.01),
              Text(
                'This card must be validated upon boarding',
                style: TextStyle(
                  fontSize: width * 0.035,
                  color: Colors.grey.shade700,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: height * 0.005),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: width * 0.02),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.blue.shade800,
                        width: width * 0.005,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: width * 0.1,
                      backgroundImage: NetworkImage('http://192.168.1.3:5000/uploads/${user['photo_profil']}'),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user['nom'],
                          style: TextStyle(
                            fontSize: width * 0.045,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                           user['prenom'],
                          style: TextStyle(
                            fontSize: width * 0.045,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  QrImageView(
                    data: code, 
                    version: QrVersions.auto,
                    size: width * 0.25,
                  ),
                ],
              ),
               SizedBox(height: height * 0.01),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  code,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BackCard extends StatelessWidget {
  final double width;
  final double height;

  const BackCard({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return CardBackground(
      cardWidth: width * 0.9,
      cardHeight: height * 0.3,
      child: Stack(
        children: [
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(3.1416), 
            child: Opacity(
              opacity: 0.5,
              child: SizedBox.expand(
                child: Image.asset(
                  'assets/patterns/tram.png',
                  fit: BoxFit.cover, 
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
class CardBackground extends StatelessWidget {
  final Widget child;
  final double cardWidth;
  final double cardHeight;
  final List<Color> gradientColors;
  final String patternImage;

  const CardBackground({
    super.key,
    required this.child,
   required this.cardWidth,
    required this.cardHeight,
    this.gradientColors = const [Colors.blueAccent, Colors.white],
    this.patternImage = 'assets/patterns/waves.jpg',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
         
          _buildGeometricDecorations(),
   
          _buildPatternBackground(),
        
          Padding(
            padding: const EdgeInsets.all(24),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildPatternBackground() {
    return Positioned.fill(
      child: Opacity(
        opacity: 0.15,
        child: Image.asset(
          patternImage,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildGeometricDecorations() {
    return Stack(
      children: [
        Positioned(
          top: -40,
          right: -30,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
        ),
        Positioned(
          bottom: -50,
          left: -20,
          child: Transform.rotate(
            angle: 0.5,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.blueAccent.withOpacity(0.08),
              ),
            ),
          ),
        ),
      ],
    );
  }
}