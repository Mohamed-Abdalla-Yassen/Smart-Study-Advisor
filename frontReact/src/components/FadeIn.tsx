// src/components/FadeIn.tsx
// Drop-in replacement for Reanimated's Animated.View with entering={FadeIn/FadeInDown/etc}
// Uses only React Native's built-in Animated API — no native modules required.

import React, { useEffect, useRef } from 'react';
import { Animated, ViewStyle, StyleProp } from 'react-native';

interface FadeInProps {
  delay?: number;
  duration?: number;
  fromY?: number; // positive = slide up from below, negative = slide down from above
  fromX?: number; // positive = slide in from right, negative = from left
  children: React.ReactNode;
  style?: StyleProp<ViewStyle>;
}

const FadeIn: React.FC<FadeInProps> = ({
  delay = 0,
  duration = 350,
  fromY = 0,
  fromX = 0,
  children,
  style,
}) => {
  const opacity = useRef(new Animated.Value(0)).current;
  const translateY = useRef(new Animated.Value(fromY)).current;
  const translateX = useRef(new Animated.Value(fromX)).current;

  useEffect(() => {
    Animated.parallel([
      Animated.timing(opacity, {
        toValue: 1,
        duration,
        delay,
        useNativeDriver: true,
      }),
      Animated.timing(translateY, {
        toValue: 0,
        duration,
        delay,
        useNativeDriver: true,
      }),
      Animated.timing(translateX, {
        toValue: 0,
        duration,
        delay,
        useNativeDriver: true,
      }),
    ]).start();
  }, []);

  return (
    <Animated.View
      style={[
        style,
        {
          opacity,
          transform: [{ translateY }, { translateX }],
        },
      ]}
    >
      {children}
    </Animated.View>
  );
};

export default FadeIn;