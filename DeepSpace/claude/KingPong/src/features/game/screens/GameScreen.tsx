import { View, Text, StyleSheet } from 'react-native'

export function GameScreen() {
  return (
    <View style={styles.container}>
      <Text style={styles.label}>KingPong</Text>
    </View>
  )
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#0A0A0A', justifyContent: 'center', alignItems: 'center' },
  label: { color: '#00FF41', fontSize: 24, fontWeight: 'bold', letterSpacing: 4 },
})
