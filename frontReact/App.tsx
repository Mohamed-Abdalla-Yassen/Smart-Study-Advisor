import React from 'react';
import { StatusBar } from 'expo-status-bar';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { SafeAreaProvider } from 'react-native-safe-area-context';

// Import Screens
import { HomeScreen } from './src/screens/HomeScreen';
import { AdvisorScreen } from './src/screens/AdvisorScreen';
import { ResultsScreen } from './src/screens/ResultsScreen';

// Import Types and Models
import { CourseResult, StudentForm } from './src/models/models';
import { AppColors } from './src/theme/theme';

// Define the navigation stack parameter list
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
  return (
    <SafeAreaProvider>
      {/* Equivalent to SystemChrome overlay style (light icons on dark background) */}
      <StatusBar style="light" backgroundColor="transparent" translucent />
      
      <NavigationContainer>
        <Stack.Navigator
          initialRouteName="Home"
          screenOptions={{
            // We hide the default header because we built custom app bars in the screens
            headerShown: false,
            // Match the app's background color during transitions
            contentStyle: { backgroundColor: AppColors.obsidian },
            // Add a slight fade animation between screens
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