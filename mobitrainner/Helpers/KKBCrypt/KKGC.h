
//
// KKGC.h
//
// Created by Kadasiddha Kullolli on 11/12/2015.
// Copyright 2015 Kadasiddha Kullolli

#if __has_feature(objc_arc)

#define KKAssign(to, from) { to = from; }
#define KKRelease(a) { a = nil; }
#define KKFree(a) { free(a); a = NULL; }

#else

/*
 * The KKAssign macro assigns the value of one object reference to another.
 */
#define KKAssign(to, from) { id __temp__ = from; KKRelease(to); to = [__temp__ retain]; }

/*
 * The KKRelease macro releases an objective C object using the release method.
 * If the object reference is nil nothing will be released.
 * The object reference is then assigned to nil.
 */
#define KKRelease(a) { id __temp__ = a; [__temp__ release]; a = nil; }

/*
 * The KKFree macro releases a non-objective C memory buffer using the free function.
 * If the pointer is nil nothing will be freed.
 * The pointer is then assigned to nil.
 */
#define KKFree(a) { free(a); a = NULL; }

#endif