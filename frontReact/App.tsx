import React from 'react';
import { StatusBar } from 'expo-status-bar';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import { useFonts } from 'expo-font';
import { View, ActivityIndicator } from 'react-native';

import { HomeScreen } from './src/screens/HomeScreen';
import { AdvisorScreen } from './src/screens/AdvisorScreen';
import { ResultsScreen } from './src/screens/ResultsScreen';
import { CourseResult, StudentForm } from './src/models/models';
import { AppColors } from './src/theme/theme';

export type RootStackParamList = {
  Home: undefined;
  Advisor: { mode: 'ai' | 'logic' };
  Results: {
    results: CourseResult[];
    form: StudentForm;
    mode: string;
    isMock?: boolean;
  };
};

const Stack = createNativeStackNavigator<RootStackParamList>();

export default function App() {
  const [fontsLoaded] = useFonts({
    'SpaceGrotesk-SemiBold': require('./assets/fonts/SpaceGrotesk-SemiBold.ttf'),
    'Syne-Bold': require('./assets/fonts/Syne-Bold.ttf'),
  });

  if (!fontsLoaded) {
    return (
      <View style={{ flex: 1, backgroundColor: AppColors.obsidian, justifyContent: 'center', alignItems: 'center' }}>
        <ActivityIndicator color={AppColors.teal} />
      </View>
    );
  }

  return (
    <SafeAreaProvider>
      <StatusBar style="light" backgroundColor="transparent" translucent />
      <NavigationContainer>
        <Stack.Navigator
          initialRouteName="Home"
          screenOptions={{
            headerShown: false,
            contentStyle: { backgroundColor: AppColors.obsidian },
            animation: 'fade',
          }}
        >
          <Stack.Screen name="Home" component={HomeScreen} />
          <Stack.Screen name="Advisor" component={AdvisorScreen} />
          <Stack.Screen name="Results" component={ResultsScreen} />
        </Stack.Navigator>
      </NavigationContainer>
    </SafeAreaProvider>
  );
}

