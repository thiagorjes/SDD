import React, { useEffect } from 'react';
import { View, StyleSheet, Text } from 'react-native';
import { GestureHandlerRootView } from 'react-native-gesture-handler';
import Animated, {
  useSharedValue,
  useAnimatedStyle,
  withRepeat,
  withTiming,
} from 'react-native-reanimated';

export default function App() {
  const opacity = useSharedValue(0.5);

  useEffect(() => {
    opacity.value = withRepeat(withTiming(1, { duration: 1000 }), -1, true);
  }, [opacity]);

  const animatedStyle = useAnimatedStyle(() => {
    return {
      opacity: opacity.value,
    };
  });

  return (
    <GestureHandlerRootView style={styles.container}>
      <View style={styles.content}>
        <Animated.View style={[styles.box, animatedStyle]}>
          <Text style={styles.text}>KingPong POC</Text>
        </Animated.View>
        <Text style={styles.subtext}>Reanimated & Gesture Handler: OK</Text>
      </View>
    </GestureHandlerRootView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: 'rgb(0,0,0)',
  },
  content: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  box: {
    padding: 20,
    backgroundColor: 'rgb(25,25,25)',
    borderWidth: 1,
    borderColor: '#83e509',
    borderRadius: 8,
    marginBottom: 20,
  },
  text: {
    color: '#83e509',
    fontSize: 24,
    fontWeight: 'bold',
  },
  subtext: {
    color: '#83e509',
    fontSize: 16,
  },
});
